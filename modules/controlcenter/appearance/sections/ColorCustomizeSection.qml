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
    description: qsTr("Base palette affects all components globally. Region overrides let you fine-tune individual UI elements.")
    showBackground: true

    property int activeTab: 0 // 0 = base, 1 = region

    // ── Tab bar + Reset All ──
    RowLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.smaller

        // Base tab pill
        StyledRect {
            implicitWidth: _baseLbl.implicitWidth + Appearance.padding.larger * 2
            implicitHeight: _baseLbl.implicitHeight + Appearance.padding.normal * 2
            radius: Appearance.rounding.normal
            color: root.activeTab === 0
                ? ComponentColors.accentPrimary
                : Colours.layer(ComponentColors.region.shared.controls.common.surface, 3)
            border.width: root.activeTab === 0 ? 0 : 1
            border.color: Qt.alpha(ComponentColors.region.shared.controls.common.border, 0.3)
            Behavior on color { CAnim {} }

            RowLayout {
                id: _baseLbl
                anchors.centerIn: parent
                spacing: Appearance.spacing.smaller

                MaterialIcon {
                    text: "palette"
                    font.pointSize: Appearance.font.size.small
                    color: root.activeTab === 0
                        ? ComponentColors.fgAccentPrimary
                        : ComponentColors.region.shared.controls.common.text
                    Behavior on color { CAnim {} }
                }

                StyledText {
                    text: qsTr("Base")
                    font.pointSize: Appearance.font.size.small
                    color: root.activeTab === 0
                        ? ComponentColors.fgAccentPrimary
                        : ComponentColors.region.shared.controls.common.text
                    Behavior on color { CAnim {} }
                }
            }

            StateLayer {
                radius: Appearance.rounding.normal
                function onClicked(): void { root.activeTab = 0; }
            }
        }

        // Region tab pill
        StyledRect {
            implicitWidth: _regionLbl.implicitWidth + Appearance.padding.larger * 2
            implicitHeight: _regionLbl.implicitHeight + Appearance.padding.normal * 2
            radius: Appearance.rounding.normal
            color: root.activeTab === 1
                ? ComponentColors.accentPrimary
                : Colours.layer(ComponentColors.region.shared.controls.common.surface, 3)
            border.width: root.activeTab === 1 ? 0 : 1
            border.color: Qt.alpha(ComponentColors.region.shared.controls.common.border, 0.3)
            Behavior on color { CAnim {} }

            RowLayout {
                id: _regionLbl
                anchors.centerIn: parent
                spacing: Appearance.spacing.smaller

                MaterialIcon {
                    text: "account_tree"
                    font.pointSize: Appearance.font.size.small
                    color: root.activeTab === 1
                        ? ComponentColors.fgAccentPrimary
                        : ComponentColors.region.shared.controls.common.text
                    Behavior on color { CAnim {} }
                }

                StyledText {
                    text: qsTr("Region")
                    font.pointSize: Appearance.font.size.small
                    color: root.activeTab === 1
                        ? ComponentColors.fgAccentPrimary
                        : ComponentColors.region.shared.controls.common.text
                    Behavior on color { CAnim {} }
                }
            }

            StateLayer {
                radius: Appearance.rounding.normal
                function onClicked(): void { root.activeTab = 1; }
            }
        }

        Item { Layout.fillWidth: true }

        // Reset All
        StyledRect {
            implicitWidth: _resetRow.implicitWidth + Appearance.padding.larger * 2
            implicitHeight: _resetRow.implicitHeight + Appearance.padding.normal * 2
            radius: Appearance.rounding.normal
            color: Colours.layer(ComponentColors.region.shared.controls.button.tonalBg, 2)

            RowLayout {
                id: _resetRow
                anchors.centerIn: parent
                spacing: Appearance.spacing.smaller

                MaterialIcon {
                    text: "restart_alt"
                    font.pointSize: Appearance.font.size.small
                    color: ComponentColors.region.shared.controls.button.tonalText
                }

                StyledText {
                    text: qsTr("Reset all")
                    font.pointSize: Appearance.font.size.small
                    color: ComponentColors.region.shared.controls.button.tonalText
                }
            }

            StateLayer {
                radius: Appearance.rounding.normal
                function onClicked(): void { ComponentColors.resetAll(); }
            }
        }
    }

    // ── Hint text ──
    StyledText {
        Layout.fillWidth: true
        visible: root.activeTab === 1
        text: qsTr("These override the base palette for specific UI components. Only changed tokens are stored.")
        font.pointSize: Appearance.font.size.smaller
        color: ComponentColors.region.shared.controls.common.subtext
        wrapMode: Text.Wrap
        opacity: 0.8
    }

    // ── Base token groups (the 60 semantic tokens) ──
    Repeater {
        model: root.activeTab === 0 ? ComponentColors.tokenGroups : null

        delegate: CollapsibleSection {
            id: baseGroup

            required property var modelData
            required property int index

            Layout.fillWidth: true
            title: modelData.group
            nested: true
            showBackground: true

            Repeater {
                model: baseGroup.modelData.tokens

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

    // ── Region token groups (curated: bar / launcher / utilities) ──
    Repeater {
        model: root.activeTab === 1 ? ComponentColors.curatedRegionTokens : null

        delegate: CollapsibleSection {
            id: regionGroup

            required property var modelData
            required property int index

            Layout.fillWidth: true
            title: modelData.group
            nested: true
            showBackground: true

            Repeater {
                model: regionGroup.modelData.tokens ?? []

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
