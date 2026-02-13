pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property Item bar
    property bool showBorder: false

    anchors.fill: parent

    Timer {
        interval: 350
        running: true
        repeat: false
        onTriggered: root.showBorder = true
    }

    StyledRect {
        anchors.fill: parent
        color: (root.showBorder && ComponentColors.themeReady) ? ComponentColors.region.bar.background : "transparent"

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: mask
            maskEnabled: true
            maskInverted: true
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1
        }
    }

    Item {
        id: mask

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            anchors.fill: parent
            anchors.margins: Config.border.thickness
            anchors.leftMargin: root.bar.implicitWidth
            radius: Config.border.rounding
        }
    }
}
