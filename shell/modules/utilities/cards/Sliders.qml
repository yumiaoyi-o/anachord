import qs.components
import qs.components.controls
import qs.services
import qs.config
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root

    readonly property var monitor: Brightness.getMonitor("active")
    property real screenBrightness: monitor?.brightness ?? 0

    Layout.fillWidth: true
    implicitHeight: layout.implicitHeight + Appearance.padding.large * 2

    radius: Appearance.rounding.normal
    color: Colours.layer(ComponentColors.region.utilities.card.surface)

    Connections {
        target: root.monitor
        enabled: root.monitor !== null

        function onBrightnessChanged(): void {
            root.screenBrightness = root.monitor?.brightness ?? 0;
        }
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.normal

        // Volume slider
        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.normal

            MaterialIcon {
                text: Audio.muted ? "volume_off" : "volume_up"
                color: ComponentColors.region.utilities.slider.icon
                Layout.alignment: Qt.AlignVCenter

                TapHandler {
                    onTapped: {
                        if (Audio.sink?.audio)
                            Audio.sink.audio.muted = !Audio.sink.audio.muted;
                    }
                }
            }

            CustomMouseArea {
                Layout.fillWidth: true
                implicitHeight: Appearance.padding.normal * 3

                onWheel: event => {
                    if (event.angleDelta.y > 0)
                        Audio.incrementVolume();
                    else if (event.angleDelta.y < 0)
                        Audio.decrementVolume();
                }

                StyledSlider {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    implicitHeight: parent.implicitHeight

                    value: Audio.volume
                    onMoved: Audio.setVolume(value)

                    Behavior on value {
                        Anim {}
                    }
                }
            }
        }

        // Brightness slider (only shown when a monitor is available)
        RowLayout {
            Layout.fillWidth: true
            visible: root.monitor !== null
            spacing: Appearance.spacing.normal

            MaterialIcon {
                text: "brightness_medium"
                color: ComponentColors.region.utilities.slider.icon
                Layout.alignment: Qt.AlignVCenter
            }

            CustomMouseArea {
                Layout.fillWidth: true
                implicitHeight: Appearance.padding.normal * 3

                onWheel: event => {
                    if (!root.monitor) return;
                    const step = Config.services.brightnessIncrement;
                    if (event.angleDelta.y > 0)
                        root.monitor.setBrightness(root.monitor.brightness + step);
                    else if (event.angleDelta.y < 0)
                        root.monitor.setBrightness(root.monitor.brightness - step);
                }

                StyledSlider {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    implicitHeight: parent.implicitHeight

                    value: root.screenBrightness
                    onMoved: {
                        root.screenBrightness = value;
                        root.monitor?.setBrightness(value);
                    }

                    Behavior on value {
                        Anim {}
                    }
                }
            }
        }
    }
}
