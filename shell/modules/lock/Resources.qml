import qs.components
import qs.components.controls
import qs.components.misc
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

GridLayout {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: Appearance.padding.large

    rowSpacing: Appearance.spacing.large
    columnSpacing: Appearance.spacing.large
    rows: 2
    columns: 2

    Ref {
        service: SystemUsage
    }

    Resource {
        Layout.topMargin: Appearance.padding.large
        icon: "memory"
        value: SystemUsage.cpuPerc
        colour: ComponentColors.region.lock.accent
    }

    Resource {
        Layout.topMargin: Appearance.padding.large
        icon: "thermostat"
        value: Math.min(1, SystemUsage.cpuTemp / 90)
        colour: ComponentColors.region.lock.accentSecondary
    }

    Resource {
        Layout.bottomMargin: Appearance.padding.large
        icon: "memory_alt"
        value: SystemUsage.memPerc
        colour: ComponentColors.region.lock.accentSecondary
    }

    Resource {
        Layout.bottomMargin: Appearance.padding.large
        icon: "hard_disk"
        value: SystemUsage.storagePerc
        colour: ComponentColors.region.lock.accentTertiary
    }

    component Resource: StyledRect {
        id: res

        required property string icon
        required property real value
        required property color colour

        Layout.fillWidth: true
        implicitHeight: width

        color: Colours.layer(ComponentColors.region.lock.surfaceHigh, 2)
        radius: Appearance.rounding.large

        CircularProgress {
            id: circ

            anchors.fill: parent
            value: res.value
            padding: Appearance.padding.large * 3
            fgColour: res.colour
            bgColour: Colours.layer(ComponentColors.region.lock.surfaceHighest, 3)
            strokeWidth: width < 200 ? Appearance.padding.smaller : Appearance.padding.normal
        }

        MaterialIcon {
            id: icon

            anchors.centerIn: parent
            text: res.icon
            color: res.colour
            font.pointSize: (circ.arcRadius * 0.7) || 1
            font.weight: 600
        }

        Behavior on value {
            Anim {
                duration: Appearance.anim.durations.large
            }
        }
    }
}
