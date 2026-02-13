pragma ComponentBehavior: Bound

import ".."
import "../components"
import qs.components
import qs.components.controls
import qs.components.effects
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root

    required property Session session

    spacing: Appearance.spacing.normal

    SettingsHeader {
        icon: "cable"
        title: qsTr("Ethernet settings")
    }

    StyledText {
        Layout.topMargin: Appearance.spacing.large
        text: qsTr("Ethernet devices")
        font.pointSize: Appearance.font.size.larger
        font.weight: 500
    }

    StyledText {
        text: qsTr("Available ethernet devices")
        color: ComponentColors.region.panel.border
    }

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: ethernetInfo.implicitHeight + Appearance.padding.large * 2

        radius: Appearance.rounding.normal
        color: Colours.layer(ComponentColors.region.panel.surface)

        ColumnLayout {
            id: ethernetInfo

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Appearance.padding.large

            spacing: Appearance.spacing.small / 2

            StyledText {
                text: qsTr("Total devices")
            }

            StyledText {
                text: qsTr("%1").arg(Nmcli.ethernetDevices.length)
                color: ComponentColors.region.panel.border
                font.pointSize: Appearance.font.size.small
            }

            StyledText {
                Layout.topMargin: Appearance.spacing.normal
                text: qsTr("Connected devices")
            }

            StyledText {
                text: qsTr("%1").arg(Nmcli.ethernetDevices.filter(d => d.connected).length)
                color: ComponentColors.region.panel.border
                font.pointSize: Appearance.font.size.small
            }
        }
    }
}
