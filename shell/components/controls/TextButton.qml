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

    property alias text: label.text
    property bool checked
    property bool toggle
    property real horizontalPadding: Appearance.padding.normal
    property real verticalPadding: Appearance.padding.smaller
    property alias font: label.font
    property int type: TextButton.Filled

    property alias stateLayer: stateLayer
    property alias label: label

    property bool internalChecked
    property color activeColour: type === TextButton.Filled ? ComponentColors.region.panel.accent : ComponentColors.region.panel.accent
    property color inactiveColour: {
        if (!toggle && type === TextButton.Filled)
            return ComponentColors.region.panel.accent;
        return type === TextButton.Filled ? Colours.tPalette.m3surfaceContainer : ComponentColors.region.panel.button.tonalBg;
    }
    property color activeOnColour: {
        if (type === TextButton.Text)
            return ComponentColors.region.panel.accent;
        return type === TextButton.Filled ? ComponentColors.region.panel.onAccent : ComponentColors.region.panel.onAccent;
    }
    property color inactiveOnColour: {
        if (!toggle && type === TextButton.Filled)
            return ComponentColors.region.panel.onAccent;
        if (type === TextButton.Text)
            return ComponentColors.region.panel.accent;
        return type === TextButton.Filled ? ComponentColors.region.panel.text : ComponentColors.region.panel.button.tonalText;
    }

    signal clicked

    onCheckedChanged: internalChecked = checked

    radius: internalChecked ? Appearance.rounding.small : implicitHeight / 2 * Math.min(1, Appearance.rounding.scale)
    color: type === TextButton.Text ? "transparent" : internalChecked ? activeColour : inactiveColour

    implicitWidth: label.implicitWidth + horizontalPadding * 2
    implicitHeight: label.implicitHeight + verticalPadding * 2

    StateLayer {
        id: stateLayer

        color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour

        function onClicked(): void {
            if (root.toggle)
                root.internalChecked = !root.internalChecked;
            root.clicked();
        }
    }

    StyledText {
        id: label

        anchors.centerIn: parent
        color: root.internalChecked ? root.activeOnColour : root.inactiveOnColour
    }

    Behavior on radius {
        Anim {}
    }
}
