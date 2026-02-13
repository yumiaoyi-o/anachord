pragma ComponentBehavior: Bound

import qs.components
import qs.components.effects
import qs.components.controls
import qs.services
import qs.utils
import qs.config
import Anachord.Services
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: root

    required property PersistentProperties visibilities

    property real playerProgress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }

    function lengthStr(length: int): string {
        if (length < 0)
            return "-1:-1";

        const hours = Math.floor(length / 3600);
        const mins = Math.floor((length % 3600) / 60);
        const secs = Math.floor(length % 60).toString().padStart(2, "0");

        if (hours > 0)
            return `${hours}:${mins.toString().padStart(2, "0")}:${secs}`;
        return `${mins}:${secs}`;
    }

    implicitWidth: cover.implicitWidth + details.implicitWidth + details.anchors.leftMargin + cavaVisualiser.implicitWidth + cavaVisualiser.anchors.leftMargin + Appearance.padding.large * 2
    implicitHeight: Math.max(cover.implicitHeight, details.implicitHeight, cavaVisualiser.implicitHeight) + Appearance.padding.large * 2

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
        service: Audio.cava
    }

    ServiceRef {
        service: Audio.beatTracker
    }



    // Radial gradient circle with opacity pulsing animation
    Rectangle {
        id: cover

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Appearance.padding.large
        implicitWidth: Config.dashboard.sizes.mediaCoverArtSize
        implicitHeight: Config.dashboard.sizes.mediaCoverArtSize
        radius: width / 2
        color: "transparent"

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
            running: Players.active?.isPlaying ?? false
            interval: 33  // ~30fps for smoother animation
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

              // Read ComponentColors into numeric channels for Canvas
              property color coreColor: ComponentColors.region.dashboard.media.cover.core
              onCoreColorChanged: requestPaint()
              property color fadeColor: ComponentColors.region.dashboard.media.cover.fade
              property real cR: coreColor.r * 255
              property real cG: coreColor.g * 255
              property real cB: coreColor.b * 255
              property real fR: fadeColor.r * 255
              property real fG: fadeColor.g * 255
              property real fB: fadeColor.b * 255
              onFadeColorChanged: requestPaint()

              onPaint: {
                  var ctx = getContext("2d");
                  var centerX = width / 2;
                  var centerY = height / 2;
                  var maxRadius = Math.min(width, height) / 2;

                  ctx.clearRect(0, 0, width, height);

                  // Audio-reactive opacity pulsing parameters - ENHANCED
                  var audioBoost = Math.max(0.3, cover.audioLevel * 1.5);  // minimum boost for visible effect
                  var phase = cover.wavePhase;

                  // Draw concentric circles with inverse square opacity and wave modulation
                  var steps = 80;
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

    ColumnLayout {
        id: details

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: cover.right
        anchors.leftMargin: Appearance.spacing.normal

        spacing: Appearance.spacing.small

        StyledText {
            id: title

            Layout.fillWidth: true
            Layout.maximumWidth: parent.implicitWidth

            animate: true
            horizontalAlignment: Text.AlignHCenter
            text: (Players.active?.trackTitle ?? qsTr("No media")) || qsTr("Unknown title")
            color: Players.active ? ComponentColors.region.dashboard.media.title.active : ComponentColors.region.dashboard.media.title.inactive
            font.pointSize: Appearance.font.size.normal
            elide: Text.ElideRight
        }

        StyledText {
            id: album

            Layout.fillWidth: true
            Layout.maximumWidth: parent.implicitWidth

            animate: true
            horizontalAlignment: Text.AlignHCenter
            visible: !!Players.active
            text: Players.active?.trackAlbum || qsTr("Unknown album")
            color: ComponentColors.region.dashboard.media.album
            font.pointSize: Appearance.font.size.small
            elide: Text.ElideRight
        }

        StyledText {
            id: artist

            Layout.fillWidth: true
            Layout.maximumWidth: parent.implicitWidth

            animate: true
            horizontalAlignment: Text.AlignHCenter
            text: (Players.active?.trackArtist ?? qsTr("Play some music for stuff to show up here!")) || qsTr("Unknown artist")
            color: Players.active ? ComponentColors.region.dashboard.media.artist.active : ComponentColors.region.dashboard.media.artist.inactive
            elide: Text.ElideRight
            wrapMode: Players.active ? Text.NoWrap : Text.WordWrap
        }

        RowLayout {
            id: controls

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Appearance.spacing.small
            Layout.bottomMargin: Appearance.spacing.smaller

            spacing: Appearance.spacing.small

            PlayerControl {
                type: IconButton.Text
                icon: "skip_previous"
                font.pointSize: Math.round(Appearance.font.size.large * 1.5)
                disabled: !Players.active?.canGoPrevious
                onClicked: Players.active?.previous()
            }

            PlayerControl {
                icon: Players.active?.isPlaying ? "pause" : "play_arrow"
                label.animate: true
                toggle: true
                activeColour: Qt.alpha(ComponentColors.region.dashboard.media.controls.playPauseBg, Colours.tPalette.m3surfaceContainer.a)
                activeOnColour: ComponentColors.region.dashboard.media.controls.playPause
                inactiveOnColour: ComponentColors.region.dashboard.media.controls.playPause
                padding: Appearance.padding.small / 2
                checked: Players.active?.isPlaying ?? false
                font.pointSize: Math.round(Appearance.font.size.large * 1.5)
                disabled: !Players.active?.canTogglePlaying
                onClicked: Players.active?.togglePlaying()
            }

            PlayerControl {
                type: IconButton.Text
                icon: "skip_next"
                font.pointSize: Math.round(Appearance.font.size.large * 1.5)
                disabled: !Players.active?.canGoNext
                onClicked: Players.active?.next()
            }
        }

        StyledSlider {
            id: slider

            enabled: !!Players.active
            implicitWidth: 280
            implicitHeight: Appearance.padding.normal * 3

            onMoved: {
                const active = Players.active;
                if (active?.canSeek && active?.positionSupported)
                    active.position = value * active.length;
            }

            Binding {
                target: slider
                property: "value"
                value: root.playerProgress
                when: !slider.pressed
            }

            CustomMouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton

                function onWheel(event: WheelEvent) {
                    const active = Players.active;
                    if (!active?.canSeek || !active?.positionSupported)
                        return;

                    event.accepted = true;
                    const delta = event.angleDelta.y > 0 ? 10 : -10;    // Time 10 seconds
                    Qt.callLater(() => {
                        active.position = Math.max(0, Math.min(active.length, active.position + delta));
                    });
                }
            }
        }

        Item {
            Layout.fillWidth: true
            implicitHeight: Math.max(position.implicitHeight, length.implicitHeight)

            StyledText {
                id: position

                anchors.left: parent.left

                text: root.lengthStr(Players.active?.position ?? -1)
                color: ComponentColors.region.dashboard.media.position
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                id: length

                anchors.right: parent.right

                text: root.lengthStr(Players.active?.length ?? -1)
                color: ComponentColors.region.dashboard.media.length
                font.pointSize: Appearance.font.size.small
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Appearance.spacing.small

            PlayerControl {
                type: IconButton.Text
                icon: "move_up"
                inactiveOnColour: ComponentColors.region.dashboard.media.controls.raise
                padding: Appearance.padding.small
                font.pointSize: Appearance.font.size.large
                disabled: !Players.active?.canRaise
                onClicked: {
                    Players.active?.raise();
                    root.visibilities.dashboard = false;
                }
            }

            SplitButton {
                id: playerSelector

                disabled: !Players.list.length
                active: menuItems.find(m => m.modelData === Players.active) ?? menuItems[0] ?? null
                menu.onItemSelected: item => Players.manualActive = item.modelData

                menuItems: playerList.instances
                fallbackIcon: "music_off"
                fallbackText: qsTr("No players")

                label.Layout.maximumWidth: slider.implicitWidth * 0.28
                label.elide: Text.ElideRight

                stateLayer.disabled: true
                menuOnTop: true

                Variants {
                    id: playerList

                    model: Players.list

                    MenuItem {
                        required property MprisPlayer modelData

                        icon: modelData === Players.active ? "check" : ""
                        text: Players.getIdentity(modelData)
                        activeIcon: "animated_images"
                    }
                }
            }

            PlayerControl {
                type: IconButton.Text
                icon: "delete"
                inactiveOnColour: ComponentColors.region.state.error
                padding: Appearance.padding.small
                font.pointSize: Appearance.font.size.large
                disabled: !Players.active?.canQuit
                onClicked: Players.active?.quit()
            }
        }
    }

    // Cava Visualizer - cli-music-player style
    Item {
        id: cavaVisualiser

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: details.right
        anchors.leftMargin: Appearance.spacing.normal

        implicitWidth: cover.implicitWidth
        implicitHeight: cover.implicitHeight



        // Container for cava effect
        Rectangle {
            id: cavaContainer
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: parent.height * 0.75
            color: "transparent"

            // Adaptive bar layout (keeps density pretty at small sizes)
            readonly property int bars: Math.min(Config.services.visualiserBars,
                                                Math.max(22, Math.floor(width / 2.8)))
            readonly property real gap: 0
            readonly property real barWidth: width / bars

            // Bottom baseline
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 2
                color: ComponentColors.region.dashboard.media.visualiser.baseline
                anchors.bottomMargin: 4
            }

            // Cava bars (shared visualiser style)
            Repeater {
                model: cavaContainer.bars

                ClippingRectangle {
                    required property int index
                    readonly property int sourceIndex: Math.round(index * (Config.services.visualiserBars - 1)
                                                                / Math.max(1, cavaContainer.bars - 1))
                    readonly property real barValue: Math.max(0.02, Math.min(1, Audio.cava.values[sourceIndex] ?? 0))

                    clip: true
                    x: index * cavaContainer.barWidth
                    y: cavaContainer.height - height - 4
                    width: cavaContainer.barWidth
                    height: barValue * (cavaContainer.height - 4)
                    color: "transparent"
                    topLeftRadius: Appearance.rounding.small * 0.6
                    topRightRadius: Appearance.rounding.small * 0.6

                    Rectangle {
                        topLeftRadius: parent.topLeftRadius
                        topRightRadius: parent.topRightRadius
                        anchors.left: parent.left
                        anchors.right: parent.right
                        y: parent.height - height
                        implicitHeight: parent.height

                        gradient: Gradient {
                            orientation: Gradient.Vertical

                            GradientStop {
                                position: 0.0
                                color: Qt.alpha(ComponentColors.region.dashboard.media.visualiser.barDim, 0.6)
                            }
                            GradientStop {
                                position: 1.0
                                color: Qt.alpha(ComponentColors.region.dashboard.media.visualiser.barBright, 0.85)
                            }
                        }
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

    component PlayerControl: IconButton {
        Layout.preferredWidth: implicitWidth + (stateLayer.pressed ? Appearance.padding.large : internalChecked ? Appearance.padding.smaller : 0)
        radius: stateLayer.pressed ? Appearance.rounding.small / 2 : internalChecked ? Appearance.rounding.small : implicitHeight / 2
        radiusAnim.duration: Appearance.anim.durations.expressiveFastSpatial
        radiusAnim.easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial

        Behavior on Layout.preferredWidth {
            Anim {
                duration: Appearance.anim.durations.expressiveFastSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveFastSpatial
            }
        }
    }
}
