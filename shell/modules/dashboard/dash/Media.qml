import qs.components
import qs.services
import qs.config
import qs.utils
import Anachord.Services
import QtQuick
import QtQuick.Shapes

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

    ServiceRef {
        service: Audio.beatTracker
    }


    // Radial gradient circle with opacity pulsing animation
    Rectangle {
        id: cover

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: Appearance.padding.large

        implicitHeight: width
        radius: width / 2
        color: "transparent"

        // Get background color from theme
        property color bgColor: Colours.layer(ComponentColors.region.dashboard.card.surface)

        // Audio level for pulsing effect
        property real audioLevel: {
            var sum = 0;
            var count = Math.min(8, Config.services.visualiserBars);
            for (var i = 0; i < count; i++) {
                sum += (Audio.cava.values[i] ?? 0);
            }
            return sum / count;
        }

        // Phase for wave animation
        property real wavePhase: 0
        
        Timer {
            running: root.visible && (Players.active?.isPlaying ?? false)
            interval: 50
            repeat: true
            onTriggered: {
                cover.wavePhase = (cover.wavePhase + 0.12) % (2 * Math.PI);
                gradientCanvas.requestPaint();
            }
        }

        // Use Canvas for radial gradient with OPACITY pulsing
        Canvas {
            id: gradientCanvas
            anchors.fill: parent
            antialiasing: true

            // Extract RGB from QML colors
            // Read ComponentColors into numeric channels for Canvas
            property color coreColor: ComponentColors.region.dashboard.dashMedia.cover.core
            property color fadeColor: ComponentColors.region.dashboard.dashMedia.cover.fade
            property real cR: coreColor.r * 255
            property real cG: coreColor.g * 255
            property real cB: coreColor.b * 255
            property real fR: fadeColor.r * 255
            property real fG: fadeColor.g * 255
            property real fB: fadeColor.b * 255
            onCoreColorChanged: requestPaint()
            onFadeColorChanged: requestPaint()
            onPaint: {
                var ctx = getContext("2d");
                var centerX = width / 2;
                var centerY = height / 2;
                var maxRadius = Math.min(width, height) / 2;

                ctx.clearRect(0, 0, width, height);

                // Audio-reactive opacity pulsing parameters - ENHANCED
                var audioBoost = Math.max(0.3, cover.audioLevel * 1.5);
                var phase = cover.wavePhase;

                // Draw concentric circles with inverse square opacity and wave modulation
                var steps = 48;
                for (var i = steps; i >= 0; i--) {
                    var t = i / steps;  // 0 at center, 1 at edge
                    var r = t * maxRadius;
                    
                    // ENHANCED Wave effect: multiple waves pulsing outward
                    var wave1 = Math.sin(t * 6 * Math.PI - phase) * 0.5 + 0.5;
                    var wave2 = Math.sin(t * 4 * Math.PI - phase * 1.5) * 0.3 + 0.5;
                    var wave = (wave1 + wave2) / 2;
                    var waveIntensity = wave * audioBoost * (1 - t * 0.3);
                    
                    // Inverse square: opacity = 1 / (1 + k * r^2)
                    var baseOpacity = 1.0 / (1.0 + 5 * t * t);
                    // ENHANCED pulsing to opacity - more dramatic
                    var opacity = Math.min(1, baseOpacity * (0.6 + waveIntensity * 0.8));
                    
                    // Color interpolation: accent → surface (seamless fade)
                    var colorR = Math.round(cR + (fR - cR) * t);
                    var colorG = Math.round(cG + (fG - cG) * t);
                    var colorB = Math.round(cB + (fB - cB) * t);
                    
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, r, 0, 2 * Math.PI);
                    ctx.fillStyle = "rgba(" + colorR + "," + colorG + "," + colorB + "," + opacity + ")";
                    ctx.fill();
                }
            }

            Component.onCompleted: requestPaint()
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
        color: ComponentColors.region.dashboard.dashMedia.title
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
        color: ComponentColors.region.dashboard.dashMedia.album
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
        color: ComponentColors.region.dashboard.dashMedia.artist

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
            iconColor: ComponentColors.region.dashboard.dashMedia.controls.playPause

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
            color: ComponentColors.region.dashboard.dashMedia.visualiser.baseline
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
                        GradientStop { position: 0.0; color: Qt.alpha(ComponentColors.region.dashboard.dashMedia.visualiser.barDim, 0.6) }
                        GradientStop { position: 1.0; color: Qt.alpha(ComponentColors.region.dashboard.dashMedia.visualiser.barBright, 0.85) }
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
        property color iconColor: ComponentColors.region.dashboard.dashMedia.controls.skip
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
            color: control.canUse ? control.iconColor : ComponentColors.region.dashboard.dashMedia.controls.disabled
            font.pointSize: Appearance.font.size.large
        }
    }
}
