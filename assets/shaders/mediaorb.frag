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
    vec4 uParamsA; // x=smoothN, y=audio, z=phase
    vec4 uParamsB; // x=glowOpacity, y=mediumOpacity, z=coreOpacity, w=spread
};

const float PI = 3.14159265358979323846;
const int MAX_LINES = 24;

float clamp01(float v) {
    return clamp(v, 0.0, 1.0);
}

float softWall(float px, float cx, float halfW, float K) {
    float x = (px - cx) / halfW;
    float ax = abs(x);
    float att = pow(K / (K + pow(ax, K)), K);
    return cx + x * halfW * att;
}

void main() {
    vec2 pos = qt_TexCoord0 * vec2(uWidth, uHeight);

    float smoothN = max(1.0, min(float(MAX_LINES), uParamsA.x));
    float au = clamp01(uParamsA.y);
    float p = uParamsA.z;

    int n = int(ceil(smoothN));
    float frac = smoothN - floor(smoothN);

    float ga = max(0.0, uParamsB.x);
    float ma = max(0.0, uParamsB.y);
    float ca = max(0.0, uParamsB.z);
    float spread = max(1.0, uParamsB.w);

    float pad = 1.5;
    float halfW = max(1.0, (uWidth - pad * 2.0) * 0.5);
    float cx = uWidth * 0.5;
    float K = 3.5 + au * 1.5;

    float yn = pos.y / max(1.0, uHeight);
    float sinBase = sin(yn * PI);
    float conv = pow(max(0.0, sinBase), 2.0);
    float env = pow(max(0.0, sinBase), 2.5);

    vec3 rgb = vec3(0.0);
    float alphaAccum = 0.0;

    for (int i = 0; i < MAX_LINES; i++) {
        if (i >= n) break;

        float t = (n > 1) ? float(i) / float(n - 1) : 0.5;
        float d = abs(t - 0.5) * 2.0;
        float baseOx = (t - 0.5) * spread;
        float lb = 0.5 + 0.5 * sin(p * 0.8 + float(i) * 0.5);

        float fadeIn = 1.0;
        if (n > 1 && frac > 0.001 && (i == 0 || i == n - 1)) {
            fadeIn = frac;
        }

        float f1 = 0.011 + float(i) * 0.0025;
        float f2 = 0.006 + float(i) * 0.002;
        float f3 = 0.019 + float(i) * 0.001;
        float po = float(i) * 1.1;

        float bAmp = (8.0 + lb * 6.0) * (1.0 - d * 0.25);
        float aAmp = au * 22.0;

        float y = pos.y;
        float ox = baseOx * conv;

        float w1 = sin(y * f1 + p + po);
        float w2 = sin(y * f2 - p * 0.7 + po * 0.5) * 0.55;
        float w3 = sin(y * f3 + p * 1.2 + float(i) * 0.8) * 0.3;
        float tex = sin(y * 0.08 + p * 0.5 + float(i) * 2.1) * 0.6 * lb;
        float rp = (au > 0.0) ? sin(y * 0.05 - p * 3.0 + float(i) * 0.9) * aAmp : 0.0;

        float disp = ((w1 + w2 + w3 + tex) * bAmp + rp) * env;
        float px = softWall(cx + ox + disp, cx, halfW, K);
        float dist = abs(pos.x - px);

        for (int pass = 0; pass < 3; pass++) {
            float lw;
            float lineAlpha;
            if (pass == 0) {
                lw = (6.0 - d * 2.5) * (0.35 + lb * 0.25 + au * 0.5);
                lineAlpha = (ga - d * 0.02) * (0.7 + lb * 0.4 + au * 0.5);
            } else if (pass == 1) {
                lw = (3.0 - d * 1.0) * (0.45 + lb * 0.35 + au * 0.7);
                lineAlpha = (ma - d * 0.05) * (0.6 + lb * 0.5 + au * 0.5);
            } else {
                lw = max(0.8, (1.8 - d * 0.5) * (0.6 + lb * 0.5 + au * 1.0));
                lineAlpha = (ca - d * 0.2) * (0.55 + lb * 0.5 + au * 0.35);
            }

            float colorT = (pass == 2) ? d * 0.6 + sin(p * 0.3 + float(i)) * 0.15 : d;
            vec3 lineColor = mix(uC1.rgb, uC2.rgb, clamp01(colorT));

            float halfLine = max(0.5, lw * (0.5 + 0.5 * fadeIn) * 0.5);
            float edgeIn = max(0.0, halfLine - 0.8);
            float edgeOut = halfLine + 0.8;
            float mask = 1.0 - smoothstep(edgeIn, edgeOut, dist);
            float a = max(0.0, lineAlpha * fadeIn) * mask;

            if (pass < 2) {
                rgb += lineColor * a;
                alphaAccum += a;
            } else {
                float aClamped = clamp01(a);
                rgb = mix(rgb, lineColor, aClamped);
                alphaAccum = alphaAccum + aClamped * (1.0 - alphaAccum);
            }
        }
    }

    float outA = clamp01(alphaAccum) * qt_Opacity;
    vec3 outRgb = min(rgb, vec3(1.0)) * qt_Opacity;
    fragColor = vec4(outRgb, outA);
}
