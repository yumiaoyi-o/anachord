#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float uTime;
    float uWidth;
    float uHeight;
    vec4 uLineCol;      // rgb=line color, a=unused
    vec4 uWaveParams;   // x=xGap, y=amplitude, z=noiseScale, w=animSpeed
    vec4 uLayerOpacity; // x=glow, y=medium, z=core (0-1), w=pointDensity
    vec4 uLayerWidth;   // x=glow, y=medium, z=core (px)
};

// ── Perlin gradient noise ──
vec2 grad(vec2 p) {
    float a = fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453) * 6.2831853;
    return vec2(cos(a), sin(a));
}

float perlin2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
    float n00 = dot(grad(i), f);
    float n10 = dot(grad(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0));
    float n01 = dot(grad(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0));
    float n11 = dot(grad(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0));
    return mix(mix(n00, n10, u.x), mix(n01, n11, u.x), u.y);
}

void main() {
    vec2 pos = qt_TexCoord0 * vec2(uWidth, uHeight);
    float t = uTime;

    float xGap = uWaveParams.x;
    float amplitude = uWaveParams.y;
    float noiseScale = uWaveParams.z;
    float animSpeed = uWaveParams.w;
    float pointDensity = uLayerOpacity.w;

    float oWidth = uWidth + amplitude * 8.0;
    float totalLines = ceil(oWidth / xGap);
    float xStart = (uWidth - xGap * totalLines) * 0.5;
    float nearIdx = floor((pos.x - xStart) / xGap + 0.5);
    float searchRange = ceil(amplitude * 2.0 / xGap) + 2.0;

    float minDist = 999.0;

    for (float di = -20.0; di <= 20.0; di += 1.0) {
        if (abs(di) > searchRange) continue;
        float idx = nearIdx + di;
        float bx = xStart + idx * xGap;

        float move = perlin2(vec2(
            (bx + t * 0.0125 * animSpeed) * 0.002 * pointDensity,
            (pos.y + t * 0.005 * animSpeed) * 0.0015 * pointDensity
        )) * noiseScale;
        float waveX = cos(move) * amplitude;

        minDist = min(minDist, abs(pos.x - (bx + waveX)));
    }

    // ═══ 3-layer line rendering (matching MediaOrb glow/medium/core) ═══
    vec3 col = uLineCol.rgb;

    // Glow: wide soft halo
    float glowA   = smoothstep(uLayerWidth.x, 0.0, minDist) * uLayerOpacity.x;
    // Medium: mid-width
    float mediumA = smoothstep(uLayerWidth.y, 0.0, minDist) * uLayerOpacity.y;
    // Core: crisp thin line
    float coreA   = smoothstep(uLayerWidth.z, 0.0, minDist) * uLayerOpacity.z;

    // Combine: glow + medium + core (pseudo-additive on dark bg)
    float a = min(1.0, glowA + mediumA + coreA) * qt_Opacity;

    fragColor = vec4(col * a, a);
}
