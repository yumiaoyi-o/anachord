pragma ComponentBehavior: Bound

import ".."
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Layouts

CollapsibleSection {
    id: root

    title: qsTr("Colors")
    description: qsTr("Customize component colors. Click the swatch to open HSL picker, edit hex directly, or reset to defaults.")
    showBackground: true

    // "Reset All" button
    RowLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal

        Item { Layout.fillWidth: true }

        StyledRect {
            implicitWidth: resetAllRow.implicitWidth + Appearance.padding.larger * 2
            implicitHeight: resetAllRow.implicitHeight + Appearance.padding.normal * 2
            radius: Appearance.rounding.normal
            color: Colours.layer(ComponentColors.region.panel.button.tonalBg, 2)

            RowLayout {
                id: resetAllRow
                anchors.centerIn: parent
                spacing: Appearance.spacing.smaller

                MaterialIcon {
                    text: "restart_alt"
                    font.pointSize: Appearance.font.size.normal
                    color: ComponentColors.region.panel.button.tonalText
                }

                StyledText {
                    text: qsTr("Reset all to defaults")
                    font.pointSize: Appearance.font.size.small
                    color: ComponentColors.region.panel.button.tonalText
                }
            }

            StateLayer {
                radius: Appearance.rounding.normal
                function onClicked(): void {
                    ComponentColors.resetAll();
                }
            }
        }
    }

    // Token group repeater
    Repeater {
        model: ComponentColors.tokenGroups

        delegate: CollapsibleSection {
            id: groupSection

            required property var modelData
            required property int index

            Layout.fillWidth: true
            title: modelData.group
            nested: true
            showBackground: true

            Repeater {
                model: groupSection.modelData.tokens

                delegate: ColorPickerRow {
                    required property var modelData

                    label: modelData.label
                    tokenKey: modelData.key
                    hint: modelData.hint ?? ""
                    value: ComponentColors.getColor(modelData.key)
                    isOverridden: ComponentColors.isOverridden(modelData.key)

                    onColorChanged: function (key, color) {
                        ComponentColors.setColor(key, color);
                    }
                    onColorReset: function (key) {
                        ComponentColors.resetColor(key);
                    }
                }
            }
        }
    }
}
