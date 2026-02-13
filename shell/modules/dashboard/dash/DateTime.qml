pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    anchors.top: parent.top
    anchors.bottom: parent.bottom
    implicitWidth: Config.dashboard.sizes.dateTimeWidth

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: 0

        StyledText {
            Layout.bottomMargin: -(font.pointSize * 0.4)
            Layout.alignment: Qt.AlignHCenter
            text: Time.hourStr
            color: ComponentColors.region.dashboard.dateTime.hours
            font.pointSize: Appearance.font.size.extraLarge
            font.family: Appearance.font.family.clock
            font.weight: 600
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "•••"
            color: ComponentColors.region.dashboard.dateTime.separator
            font.pointSize: Appearance.font.size.extraLarge * 0.9
            font.family: Appearance.font.family.clock
        }

        StyledText {
            Layout.topMargin: -(font.pointSize * 0.4)
            Layout.alignment: Qt.AlignHCenter
            text: Time.minuteStr
            color: ComponentColors.region.dashboard.dateTime.minutes
            font.pointSize: Appearance.font.size.extraLarge
            font.family: Appearance.font.family.clock
            font.weight: 600
        }

        Loader {
            Layout.alignment: Qt.AlignHCenter

            active: Config.services.useTwelveHourClock
            visible: active

            sourceComponent: StyledText {
                text: Time.amPmStr
                color: ComponentColors.region.dashboard.dateTime.amPm
                font.pointSize: Appearance.font.size.large
                font.family: Appearance.font.family.clock
                font.weight: 600
            }
        }
    }
}
