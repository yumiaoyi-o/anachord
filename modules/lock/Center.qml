pragma ComponentBehavior: Bound

import qs.components
import qs.components.controls
import qs.components.images
import qs.services
import qs.config
import qs.utils
import Anachord.Services
import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property var lock

    readonly property string username: Quickshell.env("USER") ?? "User"
    readonly property int avatarSize: 96
    readonly property int contentWidth: 380

    spacing: 0

    // ─── Clock ───
    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 4

        readonly property color clockCol: Qt.rgba(
            ComponentColors.region.lock.typography.role.primary.r * 0.8 + ComponentColors.region.lock.visualiser.wave.tertiary.r * 0.2,
            ComponentColors.region.lock.typography.role.primary.g * 0.8 + ComponentColors.region.lock.visualiser.wave.tertiary.g * 0.2,
            ComponentColors.region.lock.typography.role.primary.b * 0.8 + ComponentColors.region.lock.visualiser.wave.tertiary.b * 0.2,
            1.0
        )

        Row {
            Layout.alignment: Qt.AlignHCenter

            readonly property int clockSize: Appearance.font.size.extraLarge * 2
            readonly property real dotSize: hourText.contentHeight * 0.07

            StyledText {
                id: hourText

                text: Qt.formatTime(new Date(), "HH")
                font.pointSize: parent.clockSize
                font.weight: Font.Thin
                font.family: Appearance.font.family.clock
                color: parent.parent.clockCol
            }

            // Two dots as colon — vertically centered on digit content
            Item {
                width: parent.dotSize * 5
                height: hourText.height

                readonly property real topPad: (hourText.height - hourText.contentHeight) / 2
                readonly property real dh: hourText.contentHeight

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: parent.topPad + parent.dh * 0.4 - height / 2
                    width: parent.parent.dotSize
                    height: width
                    radius: width / 2
                    color: ComponentColors.region.lock.visualiser.wave.tertiary
                    opacity: root.lock.breathPhase
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: parent.topPad + parent.dh * 0.6 - height / 2
                    width: parent.parent.dotSize
                    height: width
                    radius: width / 2
                    color: ComponentColors.region.lock.visualiser.wave.tertiary
                    opacity: root.lock.breathPhase
                }
            }

            StyledText {
                id: minuteText

                text: Qt.formatTime(new Date(), "mm")
                font.pointSize: parent.clockSize
                font.weight: Font.Thin
                font.family: Appearance.font.family.clock
                color: parent.parent.clockCol
            }

            Timer {
                interval: 1000
                running: root.visible
                repeat: true
                onTriggered: {
                    const now = new Date();
                    hourText.text = Qt.formatTime(now, "HH");
                    minuteText.text = Qt.formatTime(now, "mm");
                }
            }
        }

        StyledText {
            id: dateText

            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDate(new Date(), "yyyy年M月d日 dddd")
            font.pointSize: Appearance.font.size.normal
            color: parent.clockCol
            opacity: 0.4

            Timer {
                interval: 60000
                running: root.visible
                repeat: true
                onTriggered: dateText.text = Qt.formatDate(new Date(), "yyyy年M月d日 dddd")
            }
        }
    }

    Item { Layout.preferredHeight: Appearance.padding.large * 3 }

    // ─── Avatar ───
    Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: root.avatarSize
        Layout.preferredHeight: root.avatarSize

        // Breathing accent ring
        Rectangle {
            id: avatarRing

            anchors.centerIn: parent
            width: parent.width + 8
            height: parent.height + 8
            radius: width / 2
            color: "transparent"
            border.width: 1.5
            border.color: Qt.rgba(
                ComponentColors.region.lock.visualiser.wave.tertiary.r,
                ComponentColors.region.lock.visualiser.wave.tertiary.g,
                ComponentColors.region.lock.visualiser.wave.tertiary.b,
                avatarGlow.value
            )

            SequentialAnimation {
                id: avatarGlow

                property real value: 0.15

                running: root.visible
                loops: Animation.Infinite

                NumberAnimation {
                    target: avatarGlow; property: "value"
                    from: 0.1; to: 0.45
                    duration: 2500
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    target: avatarGlow; property: "value"
                    from: 0.45; to: 0.1
                    duration: 2500
                    easing.type: Easing.InOutSine
                }
            }
        }

        StyledClippingRect {
            anchors.fill: parent
            radius: width / 2
            color: ComponentColors.region.lock.card.surface.high

            MaterialIcon {
                anchors.centerIn: parent
                text: "person"
                fill: 1
                grade: 200
                font.pointSize: Math.floor(root.avatarSize / 2.5) || 1
                color: ComponentColors.region.lock.typography.role.secondary
                visible: !pfp.loaded
            }

            CachingImage {
                id: pfp

                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                path: `${Paths.home}/.face`
            }
        }
    }

    Item { Layout.preferredHeight: Appearance.padding.large }

    // ─── Username ───
    StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: root.username
        font.pointSize: Appearance.font.size.large
        font.weight: Font.Medium
        color: Qt.rgba(
            ComponentColors.region.lock.typography.role.primary.r * 0.85 + ComponentColors.region.lock.visualiser.wave.tertiary.r * 0.15,
            ComponentColors.region.lock.typography.role.primary.g * 0.85 + ComponentColors.region.lock.visualiser.wave.tertiary.g * 0.15,
            ComponentColors.region.lock.typography.role.primary.b * 0.85 + ComponentColors.region.lock.visualiser.wave.tertiary.b * 0.15,
            1.0
        )
    }

    Item { Layout.preferredHeight: Appearance.padding.large * 2.5 }

    // ─── Power buttons + media wave strip ───
    Item {
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: root.contentWidth
        Layout.preferredHeight: 48

        // Align with the icons inside the password field
        // Lock icon center ≈ leftMargin + iconSize/2
        // Arrow button center ≈ width - rightMargin - buttonSize/2
        readonly property real innerLeft: Appearance.padding.large + 2
        readonly property real innerRight: Appearance.padding.larger
        readonly property real iconCenter: innerLeft + (fprintIcon.implicitHeight + Appearance.padding.small * 2) / 2
        readonly property real arrowCenter: root.contentWidth - innerRight - (Appearance.font.size.larger * 2.2) / 2

        // Left: shutdown button (centered on lock icon)
        PowerButton {
            id: shutdownBtn
            anchors.verticalCenter: parent.verticalCenter
            x: parent.iconCenter - width / 2
            icon: "power_settings_new"
            onClicked: Quickshell.execDetached(Config.session.commands.shutdown)
        }

        // Center: horizontal media wave
        Item {
            anchors.left: shutdownBtn.right
            anchors.right: rebootBtn.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            height: 36
            clip: true

            MiniMediaWave {
                anchors.centerIn: parent
                width: parent.height
                height: parent.width
                rotation: -90
            }
        }

        // Right: reboot button (centered on arrow button)
        PowerButton {
            id: rebootBtn
            anchors.verticalCenter: parent.verticalCenter
            x: parent.arrowCenter - width / 2
            icon: "restart_alt"
            onClicked: Quickshell.execDetached(Config.session.commands.reboot)
        }
    }

    Item { Layout.preferredHeight: Appearance.padding.large }

    // ─── Password field ───
    StyledRect {
        id: passwordField

        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: root.contentWidth
        Layout.minimumWidth: root.contentWidth
        implicitHeight: Appearance.padding.large * 3.5

        radius: Appearance.rounding.full
        color: Qt.rgba(
            ComponentColors.region.lock.card.surface.base.r,
            ComponentColors.region.lock.card.surface.base.g,
            ComponentColors.region.lock.card.surface.base.b,
            0.6
        )

        focus: true
        onActiveFocusChanged: {
            if (!activeFocus)
                forceActiveFocus();
        }

        Keys.onPressed: event => {
            if (root.lock.unlocking)
                return;

            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                inputField.placeholder.animate = false;

            root.lock.pam.handleKey(event);
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Appearance.padding.large + 2
            anchors.rightMargin: Appearance.padding.larger
            spacing: Appearance.spacing.normal

            // Fingerprint / lock icon + spinner
            Item {
                implicitWidth: implicitHeight
                implicitHeight: fprintIcon.implicitHeight + Appearance.padding.small * 2

                MaterialIcon {
                    id: fprintIcon

                    anchors.centerIn: parent
                    animate: true
                    text: {
                        if (root.lock.pam.fprint.tries >= Config.lock.maxFprintTries)
                            return "fingerprint_off";
                        if (root.lock.pam.fprint.active)
                            return "fingerprint";
                        return "lock";
                    }
                    color: root.lock.pam.fprint.tries >= Config.lock.maxFprintTries
                        ? ComponentColors.region.state.semantic.feedback.error : ComponentColors.region.lock.typography.role.secondary
                    opacity: root.lock.pam.authenticating ? 0 : 1

                    Behavior on opacity {
                        Anim {}
                    }
                }

                CircularIndicator {
                    anchors.fill: parent
                    running: root.lock.pam.authenticating
                }
            }

            InputField {
                id: inputField

                pam: root.lock.pam
            }

            // Submit button — circular
            StyledRect {
                implicitWidth: Appearance.font.size.larger * 2.2
                implicitHeight: Appearance.font.size.larger * 2.2
                radius: width / 2
                color: root.lock.pam.buffer
                    ? ComponentColors.region.lock.tones.role.primary
                    : "transparent"

                Behavior on color {
                    ColorAnimation { duration: Appearance.anim.durations.small }
                }

                StateLayer {
                    color: root.lock.pam.buffer
                        ? "#FFFFFF"
                        : ComponentColors.region.lock.typography.role.primary

                    function onClicked(): void {
                        if (root.lock.pam.buffer)
                            root.lock.pam.startAuth();
                    }
                }

                MaterialIcon {
                    anchors.centerIn: parent
                    text: "arrow_forward"
                    color: root.lock.pam.buffer
                        ? "#FFFFFF"
                        : ComponentColors.region.lock.typography.role.disabled
                    font.pointSize: Appearance.font.size.normal
                }
            }
        }
    }

    // ─── Error / status messages ───
    Item {
        id: msgArea

        property real targetHeight: Math.max(message.implicitHeight, stateMessage.implicitHeight, Appearance.padding.normal)

        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: root.contentWidth
        Layout.preferredHeight: targetHeight
        clip: true

        StyledText {
            id: stateMessage

            readonly property string msg: {
                const validLayout = Hypr.kbLayoutFull !== "error"
                    && Hypr.kbLayoutFull !== "Unknown"
                    && Hypr.kbLayout !== "??";
                const layoutChanged = validLayout && Hypr.kbLayout !== Hypr.defaultKbLayout;
                if (layoutChanged) {
                    if (Hypr.capsLock)
                        return qsTr("Caps lock ON · %1").arg(Hypr.kbLayoutFull);
                    return qsTr("Layout: %1").arg(Hypr.kbLayoutFull);
                }
                if (Hypr.capsLock)
                    return qsTr("Caps lock is ON");
                return "";
            }

            property bool shouldBeVisible

            onMsgChanged: {
                if (msg) {
                    text = msg;
                    shouldBeVisible = true;
                } else {
                    shouldBeVisible = false;
                }
            }

            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: ComponentColors.region.lock.typography.role.secondary
            font.pointSize: Appearance.font.size.small
            opacity: shouldBeVisible && !message.msg ? 1 : 0
            scale: shouldBeVisible && !message.msg ? 1 : 0.7

            Behavior on opacity { Anim {} }
            Behavior on scale { Anim {} }
        }

        StyledText {
            id: message

            readonly property Pam pam: root.lock.pam
            readonly property string msg: {
                if (pam.fprintState === "error")
                    return qsTr("FP ERROR: %1").arg(pam.fprint.message);
                if (pam.state === "error")
                    return qsTr("PW ERROR: %1").arg(pam.authMessage);
                if (pam.lockMessage)
                    return pam.lockMessage;
                if (pam.state === "max" && pam.fprintState === "max")
                    return qsTr("Maximum attempts reached.");
                if (pam.state === "max")
                    return qsTr("Maximum password attempts reached.");
                if (pam.fprintState === "max")
                    return qsTr("Maximum fingerprint attempts. Use password.");
                if (pam.state === "fail")
                    return qsTr("Incorrect password.");
                if (pam.fprintState === "fail")
                    return qsTr("Fingerprint not recognized (%1/%2).").arg(pam.fprint.tries).arg(Config.lock.maxFprintTries);
                return "";
            }

            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: ComponentColors.region.state.semantic.feedback.error
            font.pointSize: Appearance.font.size.small
            opacity: 0
            scale: 0.7

            onMsgChanged: {
                if (msg) {
                    text = msg;
                    exitAnim.stop();
                    appearAnim.restart();
                } else {
                    appearAnim.stop();
                    exitAnim.start();
                }
            }

            Connections {
                target: root.lock.pam

                function onFlashMsg(): void {
                    exitAnim.stop();
                    if (message.scale < 1)
                        appearAnim.restart();
                    else
                        flashAnim.restart();
                }
            }

            Anim {
                id: appearAnim
                target: message
                properties: "scale,opacity"
                to: 1
                onFinished: flashAnim.restart()
            }

            SequentialAnimation {
                id: flashAnim
                loops: 2
                NumberAnimation { target: message; property: "opacity"; to: 0.3; duration: Appearance.anim.durations.small }
                NumberAnimation { target: message; property: "opacity"; to: 1; duration: Appearance.anim.durations.small }
            }

            ParallelAnimation {
                id: exitAnim
                Anim { target: message; property: "scale"; to: 0.7; duration: Appearance.anim.durations.large }
                Anim { target: message; property: "opacity"; to: 0; duration: Appearance.anim.durations.large }
            }
        }
    }

    // ─── Power button component ───
    component PowerButton: Item {
        id: pwrBtn

        required property string icon

        signal clicked()

        implicitWidth: 44
        implicitHeight: 44

        property bool hovered: hoverArea.hovered
        property real hoverFade: 0

        Behavior on hoverFade {
            NumberAnimation { duration: 350; easing.type: Easing.InOutQuad }
        }

        onHoveredChanged: hoverFade = hovered ? 1.0 : 0.0

        HoverHandler {
            id: hoverArea
        }

        StyledRect {
            anchors.fill: parent
            radius: width / 2
            color: Qt.rgba(
                ComponentColors.region.lock.card.surface.base.r,
                ComponentColors.region.lock.card.surface.base.g,
                ComponentColors.region.lock.card.surface.base.b,
                0.4
            )

            StateLayer {
                color: ComponentColors.region.lock.typography.role.primary

                function onClicked(): void {
                    pwrBtn.clicked();
                }
            }

            // Base icon (dark gray)
            MaterialIcon {
                anchors.centerIn: parent
                text: pwrBtn.icon
                color: "#444444"
                font.pointSize: Appearance.font.size.large
            }

            // Red breathing overlay (hover-activated, synced with colon)
            MaterialIcon {
                anchors.centerIn: parent
                text: pwrBtn.icon
                color: ComponentColors.region.lock.visualiser.wave.primary
                font.pointSize: Appearance.font.size.large
                opacity: pwrBtn.hoverFade * (root.lock.breathPhase / 1.0 * 0.9)
            }
        }
    }

    // ─── Mini media wave (horizontal, MediaOrb-style) ───
    component MiniMediaWave: Item {
        id: miniWave

        readonly property bool isPlaying: Players.active?.isPlaying ?? false

        property real smoothAudio: 0
        property real rawAudio: {
            if (!isPlaying) return 0;
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
        property double lastTickMs: 0

        property real smoothN: Config.bar.mediaLines.lineCount
        property real targetN: Config.bar.mediaLines.lineCount

        property color c1: ComponentColors.region.lock.visualiser.wave.primary
        property color c2: ComponentColors.region.lock.visualiser.wave.secondary

        ServiceRef { service: Audio.cava }

        Timer {
            running: root.visible
            interval: miniWave.isPlaying ? 33 : 66
            repeat: true
            onTriggered: {
                var nowMs = Date.now();
                if (miniWave.lastTickMs <= 0)
                    miniWave.lastTickMs = nowMs;
                var dt = Math.max(16, Math.min(120, nowMs - miniWave.lastTickMs));
                miniWave.lastTickMs = nowMs;
                var frameScale = dt / 33.0;

                var targetSpeed = miniWave.isPlaying ? 0.045 : 0.018;
                miniWave.phaseSpeed += (targetSpeed - miniWave.phaseSpeed) * 0.03;
                miniWave.phase += miniWave.phaseSpeed * frameScale;
                var smoothK = 1.0 - Math.pow(1.0 - 0.02, frameScale);
                miniWave.smoothN += (miniWave.targetN - miniWave.smoothN) * smoothK;
            }
        }

        ShaderEffect {
            anchors.fill: parent

            property real uWidth: width
            property real uHeight: height
            property vector4d uC1: Qt.vector4d(miniWave.c1.r, miniWave.c1.g, miniWave.c1.b, 1.0)
            property vector4d uC2: Qt.vector4d(miniWave.c2.r, miniWave.c2.g, miniWave.c2.b, 1.0)
            property vector4d uParamsA: Qt.vector4d(
                miniWave.smoothN,
                miniWave.smoothAudio,
                miniWave.phase,
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
}
