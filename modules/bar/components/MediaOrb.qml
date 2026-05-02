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

    property real smoothAudio: 0
    property real rawAudio: {
        if (!root.isPlaying) return 0;
        var sum = 0;
        var count = Math.min(8, Config.services.visualiserBars);
        for (var i = 0; i < count; i++)
            sum += (Audio.cava.values[i] ?? 0);
        return sum / count;
    }

    onRawAudioChanged: {
        var k = rawAudio > smoothAudio ? 0.25 : 0.04;
        smoothAudio += (rawAudio - smoothAudio) * k;
    }

    property real phase: 0
    property real phaseSpeed: 0.018

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

    ServiceRef { service: Audio.cava }

    Timer {
        running: root.visible
        interval: 33
        repeat: true
        onTriggered: {
            var targetSpeed = root.isPlaying ? 0.045 : 0.018;
            root.phaseSpeed += (targetSpeed - root.phaseSpeed) * 0.03;
            root.phase += root.phaseSpeed;
            root.smoothN += (root.targetN - root.smoothN) * 0.02;
        }
    }

    ShaderEffect {
        id: shader

        anchors.fill: parent

        property real uWidth: width
        property real uHeight: height
        property vector4d uC1: Qt.vector4d(
            ComponentColors.region.bar.media.primary.r,
            ComponentColors.region.bar.media.primary.g,
            ComponentColors.region.bar.media.primary.b,
            1.0
        )
        property vector4d uC2: Qt.vector4d(
            ComponentColors.region.bar.media.secondary.r,
            ComponentColors.region.bar.media.secondary.g,
            ComponentColors.region.bar.media.secondary.b,
            1.0
        )
        property vector4d uParamsA: Qt.vector4d(
            root.smoothN,
            root.smoothAudio,
            root.phase,
            0.0
        )
        property vector4d uParamsB: Qt.vector4d(
            Config.bar.mediaLines.glowOpacity / 100,
            Config.bar.mediaLines.mediumOpacity / 100,
            Config.bar.mediaLines.coreOpacity / 100,
            width * 0.45
        )

        fragmentShader: Qt.resolvedUrl(`${Quickshell.shellDir}/assets/shaders/mediaorb.frag.qsb`)
    }
}
