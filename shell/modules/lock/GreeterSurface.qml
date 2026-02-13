pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.services
import qs.config
import qs.utils
import Anachord.Services
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

PanelWindow {
    id: root

    // Greeter surface doesn't use WlSessionLock, but Center.qml expects
    // a "lock" object with .pam, .unlocking, .breathPhase, .screen, .secure etc.
    // We provide a compatible interface via this QtObject.

    required property Pam pam

    // ── Interface expected by Center.qml ──
    readonly property alias unlocking: unlockAnim.running
    readonly property bool secure: true // always "locked" until auth
    readonly property var screen: ({ height: root.height })

    // Shared breathing phase for colon dots & power buttons
    property real breathPhase: 0.3
    SequentialAnimation on breathPhase {
        loops: Animation.Infinite
        NumberAnimation { from: 0.3; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.0; to: 0.3; duration: 2000; easing.type: Easing.InOutSine }
    }

    // Full-screen layer shell
    WlrLayershell.namespace: "anachord-greeter"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "#000000"  // Black to match Hyprland background, prevent white flash

    // Unblank VT after GreeterSurface is ready — VT stays blanked during startup
    Process {
        id: vtUnblank
        command: ["sh", "-c", "setterm --blank poke > /dev/tty1 2>/dev/null"]
    }
    Timer {
        id: readyUnblank
        interval: 80
        onTriggered: vtUnblank.running = true
    }
    Component.onCompleted: readyUnblank.start()

    // ─── Unlock (launch) animation ───
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

        onFinished: {
            // In greeter mode, Greetd.launch() already called → Qt.quit()
        }
    }

    // ─── Appear animation ───
    // ─── Appear animation (fast for greeter) ───
    ParallelAnimation {
        id: initAnim

        running: true

        Anim {
            target: maskedContent
            property: "opacity"
            from: 0; to: 1
            duration: Appearance.anim.durations.normal
        }
        Anim {
            target: centerColumn
            property: "opacity"
            from: 0; to: 1
            duration: Appearance.anim.durations.normal
        }
        Anim {
            target: centerColumn
            property: "scale"
            from: 0.95; to: 1
            duration: Appearance.anim.durations.normal
            easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
        }
    }

    // Keyboard input handler for greeter mode.
    // Center.qml's internal focus/Keys.onPressed doesn't work in PanelWindow because
    // ColumnLayout is not a FocusScope. Handle keyboard events at this level instead.
    Item {
        id: keyboardCapture
        // Don't fill parent — zero-size invisible item, only for keyboard capture
        width: 0; height: 0
        focus: true

        Keys.onPressed: event => {
            root.pam.handleKey(event);
        }

        Component.onCompleted: forceActiveFocus()
    }

    // Re-grab focus if it's lost (e.g. after a mouse click elsewhere)
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            if (!keyboardCapture.activeFocus)
                keyboardCapture.forceActiveFocus();
        }
    }

    // ─── Inner area (no border frame for greeter — full bleed) ───
    Item {
        id: innerArea

        anchors.fill: parent
        anchors.margins: 0

        Item {
            id: maskedContent

            anchors.fill: parent
            opacity: 0

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

    }

    // ─── GPU-accelerated wavy lines ───
    component WavyLines: ShaderEffect {
        id: wavesShader

        property real uTime: 0
        property color lineColor: ComponentColors.region.lock.background

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
            running: true
            repeat: true
            onTriggered: {
                wavesShader.uTime += 16;
            }
        }
    }
}
