#version 440
layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float uWidth;
    float uHeight;
    vec4 uC1;
    vec4 uC2;
    vec4 uC3;
    vec4 uParamsA; // x=smoothN, y=smoothAudio, z=phase, w=breath
    vec4 uParamsB; // x=glowAlpha, y=medAlpha, z=coreAlpha, w=spread
};

float clamp01(float v) {
    return clamp(v, 0.0, 1.0);
}

vec2 softWall(float px, float cx, float halfW, float k) {
    float x = (px - cx) / halfW;
    float ax = abs(x);
    float att = pow(k / (k + pow(ax, k)), k);
    return vec2(cx + x * halfW * att, x);
}

void main() {
    vec2 frag = qt_TexCoord0 * vec2(uWidth, uHeight);
    float x = frag.x;
    float y = frag.y;
    float w = uWidth;
    float h = uHeight;

    if (w <= 1.0 || h <= 1.0) {
        fragColor = vec4(0.0);
        return;
    }

    float phase = uParamsA.z;
    float smoothAudio = uParamsA.y;
    float smoothN = max(1.0, uParamsA.x);
    int n = int(ceil(smoothN));
    float frac = smoothN - floor(smoothN);

    float glowA = uParamsB.x;
    float medA = uParamsB.y;
    float coreA = uParamsB.z;
    float spread = uParamsB.w;

    float cx = w * 0.5;
    float pad = 1.5;
    float halfW = max(1.0, (w - pad * 2.0) * 0.5);
    float yn = y / h;

    float sinBase = sin(yn * 3.14159265);
    float conv = pow(max(sinBase, 0.0), 2.0);
    float env = pow(max(sinBase, 0.0), 2.5);

    float k = 3.5 + smoothAudio * 1.5;
    vec3 acc = vec3(0.0);
    float accA = 0.0;

    const int MAX_LINES = 64;
    for (int pass = 0; pass < 3; ++pass) {
        for (int i = 0; i < MAX_LINES; ++i) {
            if (i >= n)
                break;

            float fi = float(i);
            float t = n > 1 ? fi / float(n - 1) : 0.5;
            float d = abs(t - 0.5) * 2.0;

            float fadeIn = 1.0;
            if (n > 1 && frac > 0.001 && (i == 0 || i == n - 1))
                fadeIn = frac;

            float lb = 0.5 + 0.5 * sin(phase * 0.8 + fi * 0.5);
            float baseOx = (t - 0.5) * spread;

            float f1 = 0.011 + fi * 0.0025;
            float f2 = 0.006 + fi * 0.002;
            float f3 = 0.019 + fi * 0.001;
            float po = fi * 1.1;

            float bAmp = (8.0 + lb * 6.0) * (1.0 - d * 0.25);
            float aAmp = smoothAudio * 22.0;

            float w1 = sin(y * f1 + phase + po);
            float w2 = sin(y * f2 - phase * 0.7 + po * 0.5) * 0.55;
            float w3 = sin(y * f3 + phase * 1.2 + fi * 0.8) * 0.3;
            float tex = sin(y * 0.08 + phase * 0.5 + fi * 2.1) * 0.6 * lb;
            float rp = smoothAudio > 0.0 ? sin(y * 0.05 - phase * 3.0 + fi * 0.9) * aAmp : 0.0;
            float disp = ((w1 + w2 + w3 + tex) * bAmp + rp) * env;

            float pxRaw = cx + baseOx * conv + disp;
            float px = softWall(pxRaw, cx, halfW, k).x;

            float lw;
            float alpha;
            if (pass == 0) {
                lw = (6.0 - d * 2.5) * (0.35 + lb * 0.25 + smoothAudio * 0.5);
                alpha = (glowA - d * 0.02) * (0.7 + lb * 0.4 + smoothAudio * 0.5);
            } else if (pass == 1) {
                lw = (3.0 - d * 1.0) * (0.45 + lb * 0.35 + smoothAudio * 0.7);
                alpha = (medA - d * 0.05) * (0.6 + lb * 0.5 + smoothAudio * 0.5);
            } else {
                lw = max(0.8, (1.8 - d * 0.5) * (0.6 + lb * 0.5 + smoothAudio * 1.0));
                alpha = (coreA - d * 0.2) * (0.55 + lb * 0.5 + smoothAudio * 0.35);
            }

            float sigma = max(0.6, lw * 0.55);
            float distX = abs(x - px);
            float contrib = exp(-pow(distX / sigma, 2.0));

            float colorT = pass == 2 ? d * 0.6 + sin(phase * 0.3 + fi) * 0.15 : d;
            vec3 baseColor = mix(uC1.rgb, uC2.rgb, clamp01(colorT));
            float tertiaryMix = pass == 2 ? 0.2 * (0.3 + 0.7 * lb) : 0.08;
            vec3 col = mix(baseColor, uC3.rgb, tertiaryMix);

            float a = max(0.0, alpha) * fadeIn * contrib;
            acc += col * a;
            accA += a;
        }
    }

    float outA = clamp(accA, 0.0, 1.0);
    vec3 outColor = outA > 1e-5 ? acc / max(accA, 1e-5) : vec3(0.0);
    fragColor = vec4(outColor, outA) * qt_Opacity;
}
