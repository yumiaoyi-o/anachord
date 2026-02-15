pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import qs.utils
import Anachord.Services
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

WlSessionLockSurface {
    id: root

    required property WlSessionLock lock
    required property Pam pam

    readonly property alias unlocking: unlockAnim.running
    readonly property real splitRatio: 0.58

    // Shared breathing phase for colon dots & power buttons
    property real breathPhase: 0.3
    SequentialAnimation on breathPhase {
        running: root.visible && root.lock.locked
        loops: Animation.Infinite
        NumberAnimation { from: 0.3; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.0; to: 0.3; duration: 2000; easing.type: Easing.InOutSine }
    }

    color: ComponentColors.region.lock.background

    Connections {
        target: root.lock

        function onUnlock(): void {
            unlockAnim.start();
        }
    }

    // ─── Unlock animation ───
    ParallelAnimation {
        id: unlockAnim

        Anim {
            target: maskedContent
            property: "opacity"
            to: 0
            duration: Appearance.anim.durations.normal
        }
        Anim {
            target: centerColumn
            property: "opacity"
            to: 0
            duration: Appearance.anim.durations.small
        }
        Anim {
            target: centerColumn
            property: "scale"
            to: 0.9
            duration: Appearance.anim.durations.normal
            easing.bezierCurve: Appearance.anim.curves.emphasized
        }

        onFinished: root.lock.locked = false
    }

    // ─── Lock-in animation ───
    ParallelAnimation {
        id: initAnim

        running: true

        Anim {
            target: maskedContent
            property: "opacity"
            from: 0; to: 1
            duration: Appearance.anim.durations.large
        }
        Anim {
            target: centerColumn
            property: "opacity"
            from: 0; to: 1
            duration: Appearance.anim.durations.expressiveDefaultSpatial
        }
        Anim {
            target: centerColumn
            property: "scale"
            from: 0.9; to: 1
            duration: Appearance.anim.durations.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        }
    }

    // ─── Inner area with border frame ───
    Item {
        id: innerArea

        anchors.fill: parent
        anchors.margins: Config.border.thickness

        Item {
            id: maskedContent

            anchors.fill: parent
            opacity: 0

            layer.enabled: true
            layer.effect: MultiEffect {
                maskSource: innerMask
                maskEnabled: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }

            // Unified dark background
            StyledRect {
                anchors.fill: parent
                color: "#1a1a1a"
            }

            // Wavy lines layer (covers left portion, fades out toward right)
            Item {
                id: wavesContainer

                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.55

                layer.enabled: true
                layer.effect: MultiEffect {
                    maskSource: waveFadeMask
                    maskEnabled: true
                    maskThresholdMin: 0.5
                    maskSpreadAtMin: 1
                }

                WavyLines {
                    id: waves

                    anchors.fill: parent
                    lineColor: ComponentColors.region.lock.wave.tertiary
                }
            }

            // Gradient mask for wavy lines fade-out
            Item {
                id: waveFadeMask

                anchors.fill: wavesContainer
                layer.enabled: true
                visible: false

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#ffffffff" }
                        GradientStop { position: 0.7; color: "#ffffffff" }
                        GradientStop { position: 1.0; color: "#00ffffff" }
                    }
                }
            }

            // Login content (right panel)
            Item {
                id: rightPanel

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width * 0.50

                Center {
                    id: centerColumn

                    anchors.centerIn: parent
                    lock: root
                    opacity: 0
                    scale: 0.9
                }
            }
        }

        // Rounded mask
        Item {
            id: innerMask

            anchors.fill: parent
            layer.enabled: true
            visible: false

            Rectangle {
                anchors.fill: parent
                radius: Config.border.rounding
            }
        }
    }

    // ─── GPU-accelerated wavy lines ───
    component WavyLines: ShaderEffect {
        id: wavesShader

        property real uTime: 0
        property color lineColor: ComponentColors.region.lock.background

        // Shader uniforms
        property real uWidth: width
        property real uHeight: height
        property vector4d uLineCol: Qt.vector4d(lineColor.r, lineColor.g, lineColor.b, 1.0)
        property vector4d uWaveParams: Qt.vector4d(
            Config.lock.wavyLines.xGap,
            Config.lock.wavyLines.amplitude,
            Config.lock.wavyLines.noiseScale,
            Config.lock.wavyLines.animSpeed
        )
        property vector4d uLayerOpacity: Qt.vector4d(
            Config.lock.wavyLines.glowOpacity / 100,
            Config.lock.wavyLines.mediumOpacity / 100,
            Config.lock.wavyLines.coreOpacity / 100,
            Config.lock.wavyLines.pointDensity
        )
        property vector4d uLayerWidth: Qt.vector4d(
            Config.lock.wavyLines.glowWidth,
            Config.lock.wavyLines.mediumWidth,
            Config.lock.wavyLines.coreWidth,
            0
        )

        fragmentShader: Qt.resolvedUrl(`${Quickshell.shellDir}/assets/shaders/wavylines.frag.qsb`)

        Timer {
            interval: 16
            running: root.visible && root.lock.locked
            repeat: true
            onTriggered: {
                wavesShader.uTime += 16;
            }
        }
    }
}