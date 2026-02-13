pragma ComponentBehavior: Bound

import ".."
import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property string label
    required property string tokenKey
    required property string hint
    required property color value
    property bool isOverridden: false
    property var onColorChanged: function (key, color) {}
    property var onColorReset: function (key) {}

    Layout.fillWidth: true
    spacing: 0

    // ── Row: swatch + label + hex + reset ──
    StyledRect {
        Layout.fillWidth: true
        implicitHeight: row.implicitHeight + Appearance.padding.large * 2
        radius: Appearance.rounding.normal
        color: pickerOpen ? Colours.layer(ComponentColors.region.panel.surface, 3)
                          : Colours.layer(ComponentColors.region.panel.surface, 2)

        property bool pickerOpen: false

        Behavior on color { CAnim {} }

        RowLayout {
            id: row
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            // Color swatch
            StyledRect {
                implicitWidth: 28
                implicitHeight: 28
                radius: Appearance.rounding.small
                color: root.value
                border.width: 1
                border.color: Qt.alpha(ComponentColors.region.panel.border, 0.4)

                StyledRect {
                    anchors.fill: parent
                    z: -1
                    radius: parent.radius
                    color: "#FFFFFF"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: row.parent.pickerOpen = !row.parent.pickerOpen
                }
            }

            // Label + hint
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    text: root.label
                }
                StyledText {
                    visible: root.hint !== ""
                    text: root.hint
                    font.pointSize: Appearance.font.size.small
                    color: ComponentColors.region.panel.subtext
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }
            }

            // Locate button — highlights the actual UI area
            MaterialIcon {
                text: "my_location"
                font.pointSize: Appearance.font.size.normal
                color: ComponentColors.isHighlighted(root.tokenKey)
                           ? ComponentColors.region.panel.accent
                           : ComponentColors.region.panel.subtext
                opacity: locateArea.containsMouse ? 1.0 : 0.6

                Behavior on opacity { Anim { duration: 100 } }
                Behavior on color { CAnim {} }

                MouseArea {
                    id: locateArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ComponentColors.highlight(root.tokenKey)
                }
            }

            // Override indicator
            MaterialIcon {
                visible: root.isOverridden
                text: "edit"
                font.pointSize: Appearance.font.size.small
                color: ComponentColors.region.panel.accent
            }

            // Hex input
            StyledRect {
                implicitWidth: 90
                implicitHeight: hexInput.implicitHeight + Appearance.padding.small * 2
                radius: Appearance.rounding.small
                color: hexInput.activeFocus ? Colours.layer(ComponentColors.region.panel.surface, 3)
                                            : Colours.layer(ComponentColors.region.panel.surface, 2)
                border.width: 1
                border.color: hexInput.activeFocus ? ComponentColors.region.panel.accent
                                                   : Qt.alpha(ComponentColors.region.panel.border, 0.3)

                Behavior on color { CAnim {} }
                Behavior on border.color { CAnim {} }

                StyledTextField {
                    id: hexInput
                    anchors.centerIn: parent
                    width: parent.width - Appearance.padding.small * 2
                    horizontalAlignment: TextInput.AlignHCenter
                    text: root.value.toString().toUpperCase()
                    font.family: Appearance.font.family.mono
                    font.pointSize: Appearance.font.size.smaller

                    onEditingFinished: {
                        const hex = text.trim();
                        if (/^#[0-9A-Fa-f]{6}$/.test(hex))
                            root.onColorChanged(root.tokenKey, hex);
                        else
                            text = root.value.toString().toUpperCase();
                    }
                }
            }

            // Reset button
            Item {
                implicitWidth: resetBtn.visible ? resetBtn.implicitWidth : 0
                implicitHeight: resetBtn.visible ? resetBtn.implicitHeight : 0

                MaterialIcon {
                    id: resetBtn
                    visible: root.isOverridden
                    text: "restart_alt"
                    font.pointSize: Appearance.font.size.large
                    color: ComponentColors.region.panel.subtext

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.onColorReset(root.tokenKey)
                    }
                }
            }
        }
    }

    // ── Inline HSL picker (expands within layout) ──
    Item {
        id: pickerWrapper
        Layout.fillWidth: true
        Layout.preferredHeight: row.parent.pickerOpen ? pickerContent.implicitHeight + Appearance.spacing.smaller : 0
        clip: true
        visible: Layout.preferredHeight > 0 || pickerAnim.running

        Behavior on Layout.preferredHeight {
            Anim {
                id: pickerAnim
                easing.bezierCurve: Appearance.anim.curves.standard
            }
        }

        StyledRect {
            id: pickerContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Appearance.spacing.smaller
            radius: Appearance.rounding.normal
            color: Colours.layer(ComponentColors.region.panel.surfaceHigh, 2)
            border.width: 1
            border.color: Qt.alpha(ComponentColors.region.panel.border, 0.2)
            implicitHeight: pickerLayout.implicitHeight + Appearance.padding.large * 2

            ColumnLayout {
                id: pickerLayout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Appearance.padding.large
                spacing: Appearance.spacing.normal

                // ── Hue ──
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    StyledText {
                        text: qsTr("Hue")
                        font.pointSize: Appearance.font.size.small
                        color: ComponentColors.region.panel.subtext
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Rectangle {
                            anchors.fill: parent
                            radius: Appearance.rounding.small
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: "red" }
                                GradientStop { position: 0.167; color: "yellow" }
                                GradientStop { position: 0.333; color: "lime" }
                                GradientStop { position: 0.5; color: "cyan" }
                                GradientStop { position: 0.667; color: "blue" }
                                GradientStop { position: 0.833; color: "magenta" }
                                GradientStop { position: 1.0; color: "red" }
                            }
                        }

                        Rectangle {
                            width: 8; height: parent.height + 4; y: -2
                            x: root.value.hslHue * (parent.width - width)
                            radius: 4; color: "white"
                            border.width: 2; border.color: "#333"
                            Behavior on x { Anim { duration: Appearance.anim.durations.small } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPositionChanged: mouse => _updateHue(mouse.x)
                            onClicked: mouse => _updateHue(mouse.x)
                            function _updateHue(mx: real): void {
                                const h = Math.max(0, Math.min(1, mx / width));
                                const c = root.value;
                                root.onColorChanged(root.tokenKey, Qt.hsla(h, c.hslSaturation, c.hslLightness, 1).toString());
                            }
                        }
                    }
                }

                // ── Saturation ──
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    StyledText {
                        text: qsTr("Saturation")
                        font.pointSize: Appearance.font.size.small
                        color: ComponentColors.region.panel.subtext
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Rectangle {
                            anchors.fill: parent
                            radius: Appearance.rounding.small
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: Qt.hsla(root.value.hslHue, 0, root.value.hslLightness, 1) }
                                GradientStop { position: 1.0; color: Qt.hsla(root.value.hslHue, 1, root.value.hslLightness, 1) }
                            }
                        }

                        Rectangle {
                            width: 8; height: parent.height + 4; y: -2
                            x: root.value.hslSaturation * (parent.width - width)
                            radius: 4; color: "white"
                            border.width: 2; border.color: "#333"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPositionChanged: mouse => _updateSat(mouse.x)
                            onClicked: mouse => _updateSat(mouse.x)
                            function _updateSat(mx: real): void {
                                const s = Math.max(0, Math.min(1, mx / width));
                                const c = root.value;
                                root.onColorChanged(root.tokenKey, Qt.hsla(c.hslHue, s, c.hslLightness, 1).toString());
                            }
                        }
                    }
                }

                // ── Lightness ──
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    StyledText {
                        text: qsTr("Lightness")
                        font.pointSize: Appearance.font.size.small
                        color: ComponentColors.region.panel.subtext
                    }

                    Item {
                        Layout.fillWidth: true
                        implicitHeight: 24

                        Rectangle {
                            anchors.fill: parent
                            radius: Appearance.rounding.small
                            gradient: Gradient {
                                orientation: Gradient.Horizontal
                                GradientStop { position: 0.0; color: Qt.hsla(root.value.hslHue, root.value.hslSaturation, 0, 1) }
                                GradientStop { position: 0.5; color: Qt.hsla(root.value.hslHue, root.value.hslSaturation, 0.5, 1) }
                                GradientStop { position: 1.0; color: Qt.hsla(root.value.hslHue, root.value.hslSaturation, 1, 1) }
                            }
                        }

                        Rectangle {
                            width: 8; height: parent.height + 4; y: -2
                            x: root.value.hslLightness * (parent.width - width)
                            radius: 4; color: "white"
                            border.width: 2; border.color: "#333"
                        }

                        MouseArea {
                            anchors.fill: parent
                            onPositionChanged: mouse => _updateLight(mouse.x)
                            onClicked: mouse => _updateLight(mouse.x)
                            function _updateLight(mx: real): void {
                                const l = Math.max(0, Math.min(1, mx / width));
                                const c = root.value;
                                root.onColorChanged(root.tokenKey, Qt.hsla(c.hslHue, c.hslSaturation, l, 1).toString());
                            }
                        }
                    }
                }

                // ── Preview ──
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Appearance.spacing.normal

                    StyledRect {
                        implicitWidth: 40
                        implicitHeight: 40
                        radius: Appearance.rounding.small
                        color: root.value
                        border.width: 1
                        border.color: Qt.alpha(ComponentColors.region.panel.border, 0.3)
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: root.value.toString().toUpperCase()
                        font.family: Appearance.font.family.mono
                        font.pointSize: Appearance.font.size.small
                        color: ComponentColors.region.panel.subtext
                    }
                }
            }
        }
    }
}
