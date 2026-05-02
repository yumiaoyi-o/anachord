import qs.components
import qs.services
import qs.config
import qs.utils
import Anachord.Services
import Quickshell
import QtQuick

Item {
    id: root

    property real playerProgress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitWidth: Config.dashboard.sizes.mediaWidth

    Behavior on playerProgress {
        Anim {
            duration: Appearance.anim.durations.large
        }
    }

    Timer {
        running: Players.active?.isPlaying ?? false
        interval: Config.dashboard.mediaUpdateInterval
        triggeredOnStart: true
        repeat: true
        onTriggered: Players.active?.positionChanged()
    }

    // ─── Polar filament orb (shader-based) ───
    Item {
        id: cover

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Appearance.padding.large

        implicitHeight: width

        // ── Audio smoothing ──
        property real rawAudio: {
            var sum = 0;
            var count = Math.min(8, Config.services.visualiserBars);
            for (var i = 0; i < count; i++) {
                sum += (Audio.cava.values[i] ?? 0);
            }
            return count > 0 ? sum / count : 0;
        }

        property real smoothAudio: 0

        onRawAudioChanged: {
            var k = rawAudio > smoothAudio ? 0.25 : 0.04;
            smoothAudio += (rawAudio - smoothAudio) * k;
        }

        // ── Frequency band aggregation ──
        // Split cava bars into 8 groups → 2 × vec4 (low 4 + high 4)
        function bandAvg(startFrac: real, endFrac: real): real {
            var bars = Config.services.visualiserBars;
            var s = Math.floor(startFrac * bars);
            var e = Math.min(Math.floor(endFrac * bars), bars);
            if (e <= s) return 0;
            var sum = 0;
            for (var i = s; i < e; i++)
                sum += (Audio.cava.values[i] ?? 0);
            return sum / (e - s);
        }

        property vector4d freqLow: Qt.vector4d(
            bandAvg(0.0, 0.125),
            bandAvg(0.125, 0.25),
            bandAvg(0.25, 0.375),
            bandAvg(0.375, 0.5)
        )

        property vector4d freqHigh: Qt.vector4d(
            bandAvg(0.5, 0.625),
            bandAvg(0.625, 0.75),
            bandAvg(0.75, 0.875),
            bandAvg(0.875, 1.0)
        )

        // ── Phase animation ──
        property real phase: 0
        property real phaseSpeed: 0.018

        Timer {
            running: root.visible
            interval: 33
            repeat: true
            onTriggered: {
                var targetSpeed = (Players.active?.isPlaying ?? false) ? 0.045 : 0.018;
                cover.phaseSpeed += (targetSpeed - cover.phaseSpeed) * 0.03;
                cover.phase += cover.phaseSpeed;
            }
        }

        ShaderEffect {
            id: orbShader

            anchors.fill: parent

            property real uWidth: width
            property real uHeight: height
            property real uPhase: cover.phase
            property real uAudio: cover.smoothAudio

            property vector4d uFreqLow: cover.freqLow
            property vector4d uFreqHigh: cover.freqHigh

            property vector4d uCore: Qt.vector4d(
                ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.cover.core.r,
                ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.cover.core.g,
                ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.cover.core.b,
                1.0
            )
            property vector4d uFade: Qt.vector4d(
                ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.cover.fade.r,
                ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.cover.fade.g,
                ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.cover.fade.b,
                1.0
            )

            property vector4d uParams: Qt.vector4d(
                Config.dashboard.orb.decay,
                Config.dashboard.orb.grain,
                Config.dashboard.orb.ghostLayers,
                0.0
            )

            fragmentShader: Qt.resolvedUrl(`${Quickshell.shellDir}/assets/shaders/polar_filaments.frag.qsb`)
        }
    }

    StyledText {
        id: title

        anchors.top: cover.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Appearance.spacing.normal

        animate: true
        horizontalAlignment: Text.AlignHCenter
        text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
        color: ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.title
        font.pointSize: Appearance.font.size.normal

        width: parent.implicitWidth - Appearance.padding.large * 2
        elide: Text.ElideRight
    }

    StyledText {
        id: album

        anchors.top: title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Appearance.spacing.small

        animate: true
        horizontalAlignment: Text.AlignHCenter
        text: (Players.active?.trackAlbum ?? qsTr("No media")) || qsTr("Unknown album")
        color: ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.album
        font.pointSize: Appearance.font.size.small

        width: parent.implicitWidth - Appearance.padding.large * 2
        elide: Text.ElideRight
    }

    StyledText {
        id: artist

        anchors.top: album.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Appearance.spacing.small

        animate: true
        horizontalAlignment: Text.AlignHCenter
        text: (Players.active?.trackArtist ?? qsTr("No media")) || qsTr("Unknown artist")
        color: ComponentColors.region.dashboard.dashMedia.compact.nowPlaying.artist

        width: parent.implicitWidth - Appearance.padding.large * 2
        elide: Text.ElideRight
    }

    Row {
        id: controls

        anchors.top: artist.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Appearance.spacing.smaller

        spacing: Appearance.spacing.small

        Control {
            icon: "skip_previous"
            canUse: Players.active?.canGoPrevious ?? false

            function onClicked(): void {
                Players.active?.previous();
            }
        }

        Control {
            icon: Players.active?.isPlaying ? "pause" : "play_arrow"
            canUse: Players.active?.canTogglePlaying ?? false
            iconColor: ComponentColors.region.dashboard.dashMedia.compact.player.controls.playPause

            function onClicked(): void {
                Players.active?.togglePlaying();
            }
        }

        Control {
            icon: "skip_next"
            canUse: Players.active?.canGoNext ?? false

            function onClicked(): void {
                Players.active?.next();
            }
        }
    }

    // Cava Visualizer
    ServiceRef {
        service: Audio.cava
    }

    Item {
        id: visualiser

        anchors.top: controls.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: Appearance.spacing.normal
        anchors.bottomMargin: Appearance.padding.large * 2
        anchors.leftMargin: Appearance.padding.large * 2
        anchors.rightMargin: Appearance.padding.large * 2

        // Bottom baseline
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.95
            height: 2
            color: ComponentColors.region.dashboard.dashMedia.compact.player.visualiser.baseline
            radius: 1
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            spacing: 0
            
            Repeater {
                model: Config.services.visualiserBars

                Rectangle {
                    required property int index
                    readonly property real barValue: Math.max(0.02, Math.min(1, Audio.cava.values[index] ?? 0))

                    width: Math.max(3, (visualiser.width * 0.95) / Config.services.visualiserBars)
                    height: barValue * (visualiser.height - 6)
                    anchors.bottom: parent.bottom
                    radius: 0
                    
                    // Vertical gradient: bright at bottom (dense), dim at top (sparse)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.alpha(ComponentColors.region.dashboard.dashMedia.compact.player.visualiser.barDim, 0.6) }
                        GradientStop { position: 1.0; color: Qt.alpha(ComponentColors.region.dashboard.dashMedia.compact.player.visualiser.barBright, 0.85) }
                    }

                    Behavior on height {
                        Anim {
                            duration: 25
                        }
                    }
                }
            }
        }
    }

    component Control: StyledRect {
        id: control

        required property string icon
        required property bool canUse
        property color iconColor: ComponentColors.region.dashboard.dashMedia.compact.player.controls.skip
        function onClicked(): void {
        }

        implicitWidth: Math.max(icon.implicitHeight, icon.implicitHeight) + Appearance.padding.small
        implicitHeight: implicitWidth

        StateLayer {
            disabled: !control.canUse
            radius: Appearance.rounding.full

            function onClicked(): void {
                control.onClicked();
            }
        }

        MaterialIcon {
            id: icon

            anchors.centerIn: parent
            anchors.verticalCenterOffset: font.pointSize * 0.05

            animate: true
            text: control.icon
            color: control.canUse ? control.iconColor : ComponentColors.region.dashboard.dashMedia.compact.player.controls.disabled
            font.pointSize: Appearance.font.size.large
        }
    }
}
