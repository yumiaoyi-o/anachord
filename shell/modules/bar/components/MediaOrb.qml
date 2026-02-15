pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import qs.utils
import Anachord.Services
import Quickshell
import QtQuick

Item {
    id: root

    required property var bar

    readonly property bool isPlaying: Players.active?.isPlaying ?? false

    clip: true
    implicitWidth: Config.bar.sizes.innerWidth

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        renderStrategy: Canvas.Threaded

        property real smoothAudio: 0
        property real rawAudio: {
            if (!root.isPlaying) return 0;
            var sum = 0;
            var count = Math.min(8, Config.services.visualiserBars);
            for (var i = 0; i < count; i++)
                sum += (Audio.cava.values[i] ?? 0);
            return sum / count;
        }
        // Asymmetric smoothing: fast attack (0.25), slow decay (0.04)
        onRawAudioChanged: {
            var k = rawAudio > smoothAudio ? 0.25 : 0.04;
            smoothAudio += (rawAudio - smoothAudio) * k;
        }

        property real phase: 0
        property real phaseSpeed: 0.018
        property real breath: 0.5 + 0.5 * Math.sin(phase * 0.8)
        property double lastTickMs: 0
        property int sampleStep: 2
        property var sampleY: []
        property var sampleConv: []
        property var sampleEnv: []

          // Smooth line count for time mode (fractional, for fade-in/out)
          property real smoothN: Config.bar.mediaLines.lineCount
          property real targetN: {
              if (!Config.bar.mediaLines.timeMode)
                  return Config.bar.mediaLines.lineCount;
              var now = new Date();
              var t = now.getHours() + now.getMinutes() / 60;
              var progress = t <= 12 ? t / 12 : (24 - t) / 12;
              return Math.max(1, 1 + (Config.bar.mediaLines.lineCount - 1) * progress);
          }
        property color c1: ComponentColors.region.bar.media.primary
        property color c2: ComponentColors.region.bar.media.secondary
        property color c3: ComponentColors.region.bar.media.tertiary
        property real c1r: c1.r; property real c1g: c1.g; property real c1b: c1.b
        property real c2r: c2.r; property real c2g: c2.g; property real c2b: c2.b
        property real c3r: c3.r; property real c3g: c3.g; property real c3b: c3.b
        onC1rChanged: requestPaint()
        onC2rChanged: requestPaint()
        onC3rChanged: requestPaint()
        onHeightChanged: rebuildSamples()

        ServiceRef { service: Audio.cava }

        Timer {
            running: true
            interval: root.isPlaying ? 33 : 66
            repeat: true
            onTriggered: {
                var nowMs = Date.now();
                if (canvas.lastTickMs <= 0)
                    canvas.lastTickMs = nowMs;
                var dt = Math.max(16, Math.min(120, nowMs - canvas.lastTickMs));
                canvas.lastTickMs = nowMs;
                var frameScale = dt / 33.0;

                var targetSpeed = root.isPlaying ? 0.045 : 0.018;
                canvas.phaseSpeed += (targetSpeed - canvas.phaseSpeed) * 0.03;
                canvas.phase += canvas.phaseSpeed * frameScale;
                // Smooth line count transition
                var smoothK = 1.0 - Math.pow(1.0 - 0.02, frameScale);
                canvas.smoothN += (canvas.targetN - canvas.smoothN) * smoothK;
                canvas.requestPaint();
            }
        }

        function rebuildSamples() {
            var h = height;
            var step = sampleStep;
            if (h <= 0 || step <= 0) {
                sampleY = [];
                sampleConv = [];
                sampleEnv = [];
                return;
            }

            var ys = [];
            var convs = [];
            var envs = [];
            for (var y = 0; y <= h; y += step) {
                var yn = y / h;
                var sinBase = Math.sin(yn * Math.PI);
                ys.push(y);
                convs.push(Math.pow(sinBase, 2.0));
                envs.push(Math.pow(sinBase, 2.5));
            }

            sampleY = ys;
            sampleConv = convs;
            sampleEnv = envs;
        }

        Component.onCompleted: rebuildSamples()

        function lerp(a, b, t) { return a + (b - a) * t; }
        function clamp01(v) { return v < 0 ? 0 : v > 1 ? 1 : v; }
        function rgba(r1,g1,b1, r2,g2,b2, t, a) {
            return Qt.rgba(r1+(r2-r1)*t, g1+(g2-g1)*t, b1+(b2-b1)*t, a);
        }
        function col1(a) { return Qt.rgba(c1r, c1g, c1b, a); }
        function col2(a) { return Qt.rgba(c2r, c2g, c2b, a); }
        function colMix(t, a) { return rgba(c1r,c1g,c1b, c2r,c2g,c2b, t, a); }
        function col3Mix(t, a) { return rgba(c1r,c1g,c1b, c3r,c3g,c3b, t, a); }

        onPaint: {
            var ctx = getContext("2d");
            var w = width, h = height;
            if (w <= 0 || h <= 0) return;
            ctx.clearRect(0, 0, w, h);
            var p = phase, au = smoothAudio, br = breath, cx = w / 2;
            drawWave(ctx, w, h, p, br, au, cx);
        }

        // ═══════════════════════════════════════════════════
        // WAVE — SiriWave-inspired converging ribbons
        // Soft-wall attenuation + "lighter" blend for glow
        // Borrowed: pow(K/(K+x^K),K) attenuation from kopiro/siriwave
        // ═══════════════════════════════════════════════════
        function drawWave(ctx, w, h, p, br, au, cx) {
            var sn = canvas.smoothN;
            var n = Math.ceil(sn);  // draw this many lines
            var frac = sn - Math.floor(sn); // fractional part for fade
            if (n < 1) n = 1;
            var ga = Config.bar.mediaLines.glowOpacity / 100;
            var ma = Config.bar.mediaLines.mediumOpacity / 100;
            var ca = Config.bar.mediaLines.coreOpacity / 100;
            var ys = sampleY;
            var convs = sampleConv;
            var envs = sampleEnv;
            if (!ys || ys.length === 0) {
                rebuildSamples();
                ys = sampleY;
                convs = sampleConv;
                envs = sampleEnv;
                if (!ys || ys.length === 0) return;
            }
            var pad = 1.5;
            var halfW = (w - pad * 2) * 0.5; // usable half-width from center
            var spread = w * 0.45;

            // SiriWave-style attenuation: soft wall that absorbs energy
            // K controls wall hardness (higher = harder wall, more punch)
            var K = 3.5 + au * 1.5; // 3.5 idle → 5 at full audio
            var wallTableSize = 128;
            var wallTable = [];
            for (var wi = 0; wi <= wallTableSize; wi++) {
                var wx = wi / wallTableSize;
                wallTable.push(Math.pow(K / (K + Math.pow(wx, K)), K));
            }

            function softWall(px) {
                var x = (px - cx) / halfW;
                var ax = Math.abs(x);
                if (ax >= 1.0)
                    ax = 1.0;
                var idx = ax * wallTableSize;
                var i0 = Math.floor(idx);
                var i1 = Math.min(wallTableSize, i0 + 1);
                var tL = idx - i0;
                var att = wallTable[i0] + (wallTable[i1] - wallTable[i0]) * tL;
                return cx + x * halfW * att;
            }

            // Use "lighter" composite for glow pass, then normal for core
            for (var pass = 0; pass < 3; pass++) {
                if (pass < 2) {
                    ctx.globalCompositeOperation = "lighter";
                } else {
                    ctx.globalCompositeOperation = "source-over";
                }

                for (var i = 0; i < n; i++) {
                    var t = n > 1 ? i / (n - 1) : 0.5, d = Math.abs(t - 0.5) * 2;
                    var baseOx = (t - 0.5) * spread;
                    var lb = 0.5 + 0.5 * Math.sin(p * 0.8 + i * 0.5);

                    // Fade factor: outermost lines fade in/out with fractional count
                    var fadeIn = 1.0;
                    if (n > 1 && frac > 0.001) {
                        // The two outermost slots (first & last when n>1) fade
                        if (i === 0 || i === n - 1) fadeIn = frac;
                    }

                    var f1 = 0.011 + i * 0.0025;
                    var f2 = 0.006 + i * 0.002;
                    var f3 = 0.019 + i * 0.001;
                    var po = i * 1.1;

                    // Amplitude — let it be generous, softWall handles overflow
                    var bAmp = (8 + lb * 6) * (1 - d * 0.25);
                    var aAmp = au * 22;

                    var lw, alpha;
                    if (pass === 0) {
                        lw = (6 - d * 2.5) * (0.35 + lb * 0.25 + au * 0.5);
                        alpha = (ga - d * 0.02) * (0.7 + lb * 0.4 + au * 0.5);
                    } else if (pass === 1) {
                        lw = (3 - d * 1.0) * (0.45 + lb * 0.35 + au * 0.7);
                        alpha = (ma - d * 0.05) * (0.6 + lb * 0.5 + au * 0.5);
                    } else {
                        lw = Math.max(0.8, (1.8 - d * 0.5) * (0.6 + lb * 0.5 + au * 1.0));
                        alpha = (ca - d * 0.2) * (0.55 + lb * 0.5 + au * 0.35);
                    }

                    var colorT = pass === 2 ? d * 0.6 + Math.sin(p * 0.3 + i) * 0.15 : d;
                    ctx.lineWidth = lw * (0.5 + 0.5 * fadeIn);
                    ctx.strokeStyle = colMix(clamp01(colorT), alpha * fadeIn);
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";

                    ctx.beginPath();
                    var first = true;
                    for (var yi = 0; yi < ys.length; yi++) {
                        var y = ys[yi];
                        var conv = convs[yi];
                        var ox = baseOx * conv;
                        var env = envs[yi];

                        var w1 = Math.sin(y * f1 + p + po);
                        var w2 = Math.sin(y * f2 - p * 0.7 + po * 0.5) * 0.55;
                        var w3 = Math.sin(y * f3 + p * 1.2 + i * 0.8) * 0.3;
                        var tex = Math.sin(y * 0.08 + p * 0.5 + i * 2.1) * 0.6 * lb;
                        var rp = au > 0 ? Math.sin(y * 0.05 - p * 3.0 + i * 0.9) * aAmp : 0;

                        var disp = ((w1 + w2 + w3 + tex) * bAmp + rp) * env;
                        var px = softWall(cx + ox + disp);

                        if (first) { ctx.moveTo(px, y); first = false; }
                        else ctx.lineTo(px, y);
                    }
                    ctx.stroke();
                }
            }
            ctx.globalCompositeOperation = "source-over";
        }
    }
}
