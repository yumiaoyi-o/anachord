import qs.components
import qs.services
import qs.config
import Quickshell
import Quickshell.Io
import QtQuick

Item {
    id: root

    required property PersistentProperties visibilities
    required property var lock

    implicitWidth: icon.implicitHeight + Appearance.padding.small * 2
    implicitHeight: icon.implicitHeight

    StateLayer {
        // Cursed workaround to make the height larger than the parent
        anchors.fill: undefined
        anchors.centerIn: parent
        implicitWidth: implicitHeight
        implicitHeight: icon.implicitHeight + Appearance.padding.small * 2

        radius: Appearance.rounding.full

        function onClicked(): void {
            if (root.lock)
                root.lock.locked = true;
        }
    }

    MaterialIcon {
        id: icon

        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -1

        text: "power_settings_new"
        color: ComponentColors.region.bar.accent
        font.bold: true
        font.pointSize: Appearance.font.size.normal
    }

}
