import ".."
import qs.services
import qs.config
import QtQuick

StyledRect {
    id: root

    enum Type {
        Filled,
        Tonal,
        Text
    }

    property alias icon: label.text
    property bool checked
    property bool toggle
    property real padding: type === IconButton.Text ? Appearance.padding.small / 2 : Appearance.padding.smaller
    property alias font: label.font
    property int type: IconButton.Filled
    property bool disabled

    property alias stateLayer: stateLayer
    property alias label: label
    property alias radiusAnim: radiusAnim

    property bool internalChecked
    property color activeColour: type === IconButton.Filled ? ComponentColors.region.shared.controls.common.accent : ComponentColors.region.shared.controls.common.accent
    property color inactiveColour: {
        if (!toggle && type === IconButton.Filled)
            return ComponentColors.region.shared.controls.common.accent;
        return type === IconButton.Filled ? Qt.alpha(ComponentColors.region.shared.controls.common.surface, Colours.tPalette.m3surfaceContainer.a) : ComponentColors.region.shared.controls.button.tonalBg;
    }
    property color activeOnColour: type === IconButton.Filled ? ComponentColors.region.shared.controls.common.onAccent : type === IconButton.Tonal ? ComponentColors.region.shared.controls.common.onAccent : ComponentColors.region.shared.controls.common.accent
    property color inactiveOnColour: {
        if (!toggle && type === IconButton.Filled)
            return ComponentColors.region.shared.controls.common.onAccent;
        return type === IconButton.Tonal ? ComponentColors.region.shared.controls.button.tonalText : ComponentColors.region.shared.controls.common.subtext;
    }
    property color disabledColour: Qt.alpha(ComponentColors.region.shared.controls.common.text, 0.1)
    property color disabledOnColour: Qt.alpha(ComponentColors.region.shared.controls.common.text, 0.38)

    signal clicked

    onCheckedChanged: internalChecked = checked

    radius: internalChecked ? Appearance.rounding.small : implicitHeight / 2 * Math.min(1, Appearance.rounding.scale)
    color: type === IconButton.Text ? "transparent" : disabled ? disabledColour : internalChecked ? activeColour : inactiveColour

    implicitWidth: implicitHeight
    implicitHeight: label.implicitHeight + padding * 2

    StateLayer {
        id: stateLayer

        color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour
        disabled: root.disabled

        function onClicked(): void {
            if (root.toggle)
                root.internalChecked = !root.internalChecked;
            root.clicked();
        }
    }

    MaterialIcon {
        id: label

        anchors.centerIn: parent
        color: root.disabled ? root.disabledOnColour : root.internalChecked ? root.activeOnColour : root.inactiveOnColour
        fill: !root.toggle || root.internalChecked ? 1 : 0

        Behavior on fill {
            Anim {}
        }
    }

    Behavior on radius {
        Anim {
            id: radiusAnim
        }
    }
}
