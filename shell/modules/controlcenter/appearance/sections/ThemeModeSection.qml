pragma ComponentBehavior: Bound

import ".."
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

CollapsibleSection {
    title: qsTr("Theme mode")
    description: qsTr("Light or dark theme")
    showBackground: true

    SwitchRow {
        label: qsTr("Dark mode")
        checked: ComponentColors.isDark
        onToggled: checked => {
            ComponentColors.setDark(checked);
            Config.appearance.isDark = checked;
            Config.save();
        }
    }

    SwitchRow {
        label: qsTr("Dynamic colors")
        checked: Config.services.dynamicColors
        onToggled: checked => {
            Config.services.dynamicColors = checked;
            Config.save();
        }
    }

    SwitchRow {
        label: qsTr("Smart detection")
        checked: Config.services.smartScheme
        visible: Colours.dynamic
        onToggled: checked => {
            Config.services.smartScheme = checked;
            Config.save();
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal

        Item { Layout.fillWidth: true }

        StyledRect {
            implicitWidth: _saveGlobalRow.implicitWidth + Appearance.padding.larger * 2
            implicitHeight: _saveGlobalRow.implicitHeight + Appearance.padding.normal * 2
            radius: Appearance.rounding.normal
            color: Colours.layer(ComponentColors.region.panel.button.tonalBg, 2)

            RowLayout {
                id: _saveGlobalRow
                anchors.centerIn: parent
                spacing: Appearance.spacing.smaller

                MaterialIcon {
                    text: "save"
                    font.pointSize: Appearance.font.size.normal
                    color: ComponentColors.region.panel.button.tonalText
                }

                StyledText {
                    text: qsTr("Save as global theme")
                    font.pointSize: Appearance.font.size.small
                    color: ComponentColors.region.panel.button.tonalText
                }
            }

            StateLayer {
                radius: Appearance.rounding.normal
                function onClicked(): void {
                    ComponentColors.saveAsGlobal();
                }
            }
        }
    }
}
