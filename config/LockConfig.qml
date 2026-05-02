import Quickshell.Io

JsonObject {
    property bool recolourLogo: false
    property bool enableFprint: true
    property int maxFprintTries: 3
    property Sizes sizes: Sizes {}
    property WavyLines wavyLines: WavyLines {}

    component Sizes: JsonObject {
        property real heightMult: 0.7
        property real ratio: 16 / 9
        property int centerWidth: 600
    }

    component WavyLines: JsonObject {
        property real xGap: 5.0           // line spacing (px)
        property real amplitude: 32.0     // wave displacement (px)
        property real noiseScale: 12.0    // noise complexity
        property real animSpeed: 1.0      // animation speed multiplier
        property real pointDensity: 1.0   // wave bend density (multiplier)
        property real glowOpacity: 12     // glow layer opacity (%)
        property real mediumOpacity: 25   // medium layer opacity (%)
        property real coreOpacity: 90     // core layer opacity (%)
        property real glowWidth: 5.0      // glow smoothstep range (px)
        property real mediumWidth: 2.5    // medium smoothstep range (px)
        property real coreWidth: 0.8      // core smoothstep range (px)
    }
}
