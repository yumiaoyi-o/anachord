#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float uWidth;
    float uHeight;
    float uAudio;
    float uPhase;
    vec4 uCore;
    vec4 uFade;
};

void main() {
    vec2 uv = qt_TexCoord0 * 2.0 - 1.0;
    float aspect = uWidth / max(uHeight, 1.0);
    uv.x *= aspect;

    float r = length(uv);
    float ang = atan(uv.y, uv.x);
    float phase = uPhase;
    float audio = clamp(uAudio, 0.0, 1.0);

    float edgeMask = 1.0 - smoothstep(0.82, 1.08, r);
    float bodyMask = 1.0 - smoothstep(0.68, 0.96, r);

    vec3 bg = mix(uCore.rgb, uFade.rgb, clamp(pow(r, 1.15), 0.0, 1.0));
    bg *= 0.42 + 0.18 * bodyMask;

    float flow = phase * (0.55 + audio * 1.15);
    float spiralA = sin(ang * 2.0 + r * 16.0 - flow * 1.8);
    float spiralB = sin(ang * 3.6 - r * 12.0 + flow * 1.2 + 0.9);
    float spiralC = sin(ang * 5.2 + r * 9.0 + flow * 0.9 + 2.2);

    float filA = pow(max(0.0, spiralA * 0.5 + 0.5), 6.0);
    float filB = pow(max(0.0, spiralB * 0.5 + 0.5), 7.0);
    float filC = pow(max(0.0, spiralC * 0.5 + 0.5), 8.0);

    float radialEnv = exp(-pow((r - (0.46 + audio * 0.06)) / 0.28, 2.0));
    float stringField = (filA * 0.55 + filB * 0.65 + filC * 0.50) * radialEnv;

    float ring1 = exp(-pow((r - (0.34 + audio * 0.02 + 0.012 * sin(flow * 0.9))) / 0.055, 2.0));
    float ring2 = exp(-pow((r - (0.57 + 0.010 * sin(flow * 1.2 + 1.5))) / 0.075, 2.0));
    float rings = ring1 * (0.75 + audio * 0.35) + ring2 * 0.55;

    float micro = sin((uv.x + uv.y) * 14.0 + flow * 0.8) * 0.5 + 0.5;
    float core = exp(-pow(r / (0.24 + audio * 0.03), 2.0)) * (0.22 + 0.20 * micro);

    float gradMix = clamp(0.25 + 0.45 * sin(flow * 0.45 + ang * 1.1 - r * 3.0), 0.0, 1.0);
    vec3 filamentColor = mix(uCore.rgb, uFade.rgb, gradMix);

    vec3 color = bg;
    color += filamentColor * stringField * (0.95 + audio * 0.35);
    color += mix(uFade.rgb, uCore.rgb, 0.35) * rings * 0.55;
    color += uCore.rgb * core * 0.70;

    float alpha = (0.18 + stringField * 0.58 + rings * 0.28 + core * 0.35) * edgeMask;
    alpha = clamp(alpha, 0.0, 1.0);

    fragColor = vec4(color, alpha) * qt_Opacity;
}
