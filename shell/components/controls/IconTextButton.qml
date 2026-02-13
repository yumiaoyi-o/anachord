import ".."
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root

    enum Type {
        Filled,
        Tonal,
        Text
    }

    property alias icon: iconLabel.text
    property alias text: label.text
    property bool checked
    property bool toggle
    property real horizontalPadding: Appearance.padding.normal
    property real verticalPadding: Appearance.padding.smaller
    property alias font: label.font
    property int type: IconTextButton.Filled

    property alias stateLayer: stateLayer
    property alias iconLabel: iconLabel
    property alias label: label

    property bool internalChecked
    property color activeColour: type === IconTextButton.Filled ? ComponentColors.region.panel.accent : ComponentColors.region.panel.accent
    property color inactiveColour: type === IconTextButton.Filled ? Qt.alpha(ComponentColors.region.panel.surface, Colours.tPalette.m3surfaceContainer.a) : ComponentColors.region.panel.button.tonalBg
    property color activeOnColour: type === IconTextButton.Filled ? ComponentColors.region.panel.onAccent : ComponentColors.region.panel.onAccent
    property color inactiveOnColour: type === IconTextButton.Filled ? ComponentColors.region.panel.text : ComponentColors.region.panel.button.tonalText

    signal clicked

    onCheckedChanged: internalChecked = checked

    radius: internalChecked ? Appearance.rounding.small : implicitHeight / 2 * Math.min(1, Appearance.rounding.scale)
    color: type === IconTextButton.Text ? "transparent" : internalChecked ? activeColour : inactiveColour

    implicitWidth: row.implicitWidth + horizontalPadding * 2
    implicitHeight: row.implicitHeight + verticalPadding * 2

    StateLayer {
        id: stateLayer

        color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour

        function onClicked(): void {
            if (root.toggle)
                root.internalChecked = !root.internalChecked;
            root.clicked();
        }
    }

    RowLayout {
        id: row

        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        MaterialIcon {
            id: iconLabel

            Layout.alignment: Qt.AlignVCenter
            Layout.topMargin: Math.round(fontInfo.pointSize * 0.0575)
            color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour
            fill: root.internalChecked ? 1 : 0

            Behavior on fill {
                Anim {}
            }
        }

        StyledText {
            id: label

            Layout.alignment: Qt.AlignVCenter
            Layout.topMargin: -Math.round(iconLabel.fontInfo.pointSize * 0.0575)
            color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour
        }
    }

    Behavior on radius {
        Anim {}
    }
}
