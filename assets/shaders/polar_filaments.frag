#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float uWidth;
    float uHeight;
    float uPhase;
    float uAudio;
    vec4 uFreqLow;
    vec4 uFreqHigh;
    vec4 uCore;
    vec4 uFade;
    vec4 uParams;
};

// ═══════════════════════════════════════════════════════════
//  3-D Simplex noise  (Stefan Gustavson, MIT licence)
// ═══════════════════════════════════════════════════════════
vec3 mod289(vec3 x){ return x - floor(x * (1.0/289.0)) * 289.0; }
vec4 mod289(vec4 x){ return x - floor(x * (1.0/289.0)) * 289.0; }
float mod289(float x){ return x - floor(x * (1.0/289.0)) * 289.0; }
vec4 permute(vec4 x){ return mod289(((x*34.0)+1.0)*x); }
vec4 taylorInvSqrt(vec4 r){ return 1.79284291400159 - 0.85373472095314 * r; }

float snoise(vec3 v){
    const vec2 C = vec2(1.0/6.0, 1.0/3.0);
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);
    vec3 i  = floor(v + dot(v, C.yyy));
    vec3 x0 = v - i + dot(i, C.xxx);
    vec3 g  = step(x0.yzx, x0.xyz);
    vec3 l  = 1.0 - g;
    vec3 i1 = min(g.xyz, l.zxy);
    vec3 i2 = max(g.xyz, l.zxy);
    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy;
    vec3 x3 = x0 - D.yyy;
    i = mod289(i);
    vec4 p = permute(permute(permute(
             i.z + vec4(0.0, i1.z, i2.z, 1.0))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0))
           + i.x + vec4(0.0, i1.x, i2.x, 1.0));
    float n_ = 0.142857142857;
    vec3 ns = n_ * D.wyz - D.xzx;
    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);
    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_);
    vec4 x  = x_ * ns.x + ns.yyyy;
    vec4 y  = y_ * ns.x + ns.yyyy;
    vec4 h  = 1.0 - abs(x) - abs(y);
    vec4 b0 = vec4(x.xy, y.xy);
    vec4 b1 = vec4(x.zw, y.zw);
    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));
    vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
    vec3 p0 = vec3(a0.xy, h.x);
    vec3 p1 = vec3(a0.zw, h.y);
    vec3 p2 = vec3(a1.xy, h.z);
    vec3 p3 = vec3(a1.zw, h.w);
    vec4 norm = taylorInvSqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2,p2), dot(p3,p3)));
    p0 *= norm.x; p1 *= norm.y; p2 *= norm.z; p3 *= norm.w;
    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot(m*m, vec4(dot(p0,x0), dot(p1,x1), dot(p2,x2), dot(p3,x3)));
}

// ═══════════════════════════════════════════════════════════
//  Ridge noise
// ═══════════════════════════════════════════════════════════
float ridge(float h, float sharpness){
    float v = 1.0 - abs(h);
    return pow(v, sharpness);
}

float ridgeFBM(vec3 p, float audio, float freqLo, float freqHi, float phase){
    float warpStrength = 0.6 + audio * 0.8;
    vec3 warpOffset = vec3(
        snoise(p * 0.8 + vec3(phase * 0.15, 0.0, 0.0)),
        snoise(p * 0.8 + vec3(0.0, phase * 0.12, 17.0)),
        snoise(p * 0.8 + vec3(0.0, 0.0, phase * 0.10 + 31.0))
    ) * warpStrength;
    vec3 q = p + warpOffset;

    float n1 = ridge(snoise(q * 1.4 + vec3(phase * 0.18, 0.0, 0.0)), 2.2 + freqLo * 1.2);
    float n2 = ridge(snoise(q * 2.8 - vec3(0.0, phase * 0.22, 0.0)), 2.8);
    float n3 = ridge(snoise(q * 5.6 + vec3(0.0, 0.0, phase * 0.28)), 3.2 + freqHi * 1.2);
    float n4 = ridge(snoise(q * 11.0 + vec3(phase * 0.35, phase * 0.12, 0.0)), 3.8);

    float w1 = 0.15 + audio * 0.50 + freqLo * 0.30;
    float w2 = 0.10 + audio * 0.35;
    float w3 = 0.06 + audio * 0.30 + freqHi * 0.25;
    float w4 = 0.03 + audio * 0.20;

    return (n1 * w1 + n2 * w2 + n3 * w3 + n4 * w4);
}

// ═══════════════════════════════════════════════════════════
//  Hash for grain + jitter
// ═══════════════════════════════════════════════════════════
float hash21(vec2 p){
    p = fract(p * vec2(443.8975, 397.2973));
    p += dot(p, p.yx + 19.19);
    return fract(p.x * p.y);
}

// ═══════════════════════════════════════════════════════════
//  Main — single-pass, open boundary
// ═══════════════════════════════════════════════════════════
void main(){
    vec2 uv = qt_TexCoord0 * 2.0 - 1.0;
    float aspect = uWidth / max(uHeight, 1.0);
    uv.x *= aspect;

    float r = length(uv);

    // Soft density envelope — Gaussian, radially symmetric
    // Dense at centre, gentle tail lets some filaments leak past r=1
    float density = exp(-r * r * 2.8);

    // Truly empty corners only
    if (density < 0.002) { fragColor = vec4(0.0); return; }

    // Spherical mapping — clamp keeps it stable, density handles fade
    float theta = asin(clamp(r, 0.0, 0.999));
    float phi   = atan(uv.y, uv.x);

    vec3 spherePos = vec3(
        sin(theta) * cos(phi),
        sin(theta) * sin(phi),
        cos(theta)
    );

    // Sample position = sphere position, always radially coherent
    vec3 samplePos = spherePos;

    float audio = clamp(uAudio, 0.0, 1.0);
    float freqLo = (uFreqLow.x + uFreqLow.y + uFreqLow.z + uFreqLow.w) * 0.25;
    float freqHi = (uFreqHigh.x + uFreqHigh.y + uFreqHigh.z + uFreqHigh.w) * 0.25;
    float grainAmt = uParams.y;
    float phase = uPhase;

    // Single pass — no ghost layers
    float f = ridgeFBM(samplePos, audio, freqLo, freqHi, phase);

    // Audio-reactive radial modulation
    float radialT = clamp(r / 0.9, 0.0, 1.0);
    float radialBoost = mix(freqLo * 0.6, freqHi * 0.4, radialT);
    f *= (1.0 + radialBoost);

    // Compress: warm floor, breathing room at top
    f = mix(0.15, 0.92, clamp(f, 0.0, 1.0));

    // Glow tiers
    float core   = smoothstep(0.58, 0.82, f);
    float medium = smoothstep(0.36, 0.62, f);
    float glow   = smoothstep(0.18, 0.44, f);

    // Grain
    float grain = (hash21(qt_TexCoord0 * vec2(uWidth, uHeight) + vec2(uPhase * 100.0, 0.0)) - 0.5) * grainAmt;
    grain *= density * (0.2 + audio * 0.3);

    // Colour: only uCore hue, intensity from tiers
    float intensity = glow * 0.30 + medium * 0.40 + core * 0.55;
    intensity = max(intensity, 0.08);

    vec3 color = uCore.rgb * intensity * density;

    // Subtle core glow
    float bgGlow = density * density * (0.05 + audio * 0.04);
    color += uCore.rgb * bgGlow * 0.20;
    color += vec3(grain);

    // Alpha: purely from density × intensity — open edge dissolve
    float alpha = (intensity * 0.85 + bgGlow * 0.35) * density;
    alpha = clamp(alpha + grain * 0.04, 0.0, 1.0);

    fragColor = vec4(color, alpha) * qt_Opacity;
}
