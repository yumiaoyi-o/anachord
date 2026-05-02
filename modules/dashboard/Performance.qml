import qs.components
import qs.components.misc
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

RowLayout {
    id: root

    readonly property int padding: Appearance.padding.large

    function displayTemp(temp: real): string {
        return `${Math.ceil(Config.services.useFahrenheit ? temp * 1.8 + 32 : temp)}°${Config.services.useFahrenheit ? "F" : "C"}`;
    }

    spacing: Appearance.spacing.large * 3

    Ref {
        service: SystemUsage
    }

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: root.padding
        Layout.bottomMargin: root.padding
        Layout.leftMargin: root.padding * 2

        value1: Math.min(1, SystemUsage.gpuTemp / 90)
        value2: SystemUsage.gpuPerc

        label1: root.displayTemp(SystemUsage.gpuTemp)
        label2: `${Math.round(SystemUsage.gpuPerc * 100)}%`

        sublabel1: qsTr("GPU temp")
        sublabel2: qsTr("Usage")
    }

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: root.padding
        Layout.bottomMargin: root.padding

        primary: true

        value1: Math.min(1, SystemUsage.cpuTemp / 90)
        value2: SystemUsage.cpuPerc

        label1: root.displayTemp(SystemUsage.cpuTemp)
        label2: `${Math.round(SystemUsage.cpuPerc * 100)}%`

        sublabel1: qsTr("CPU temp")
        sublabel2: qsTr("Usage")
    }

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: root.padding
        Layout.bottomMargin: root.padding
        Layout.rightMargin: root.padding * 3

        value1: SystemUsage.memPerc
        value2: SystemUsage.storagePerc

        label1: {
            const fmt = SystemUsage.formatKib(SystemUsage.memUsed);
            return `${+fmt.value.toFixed(1)}${fmt.unit}`;
        }
        label2: {
            const fmt = SystemUsage.formatKib(SystemUsage.storageUsed);
            return `${Math.floor(fmt.value)}${fmt.unit}`;
        }

        sublabel1: qsTr("Memory")
        sublabel2: qsTr("Storage")
    }

    component Resource: Item {
        id: res

        required property real value1
        required property real value2
        required property string sublabel1
        required property string sublabel2
        required property string label1
        required property string label2

        property bool primary
        readonly property real primaryMult: primary ? 1.2 : 1

        readonly property real thickness: Config.dashboard.sizes.resourceProgessThickness * primaryMult

        property color fg1: ComponentColors.region.dashboard.performance.resource.arc.fg1
        property color fg2: ComponentColors.region.dashboard.performance.resource.arc.fg2
        property color bg1: ComponentColors.region.dashboard.performance.resource.arc.bg1
        property color bg2: ComponentColors.region.dashboard.performance.resource.arc.bg2

        implicitWidth: Config.dashboard.sizes.resourceSize * primaryMult
        implicitHeight: Config.dashboard.sizes.resourceSize * primaryMult

        Column {
            anchors.centerIn: parent

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.label1
                font.pointSize: Appearance.font.size.extraLarge * res.primaryMult
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.sublabel1
                color: ComponentColors.region.dashboard.performance.resource.sublabel
                font.pointSize: Appearance.font.size.smaller * res.primaryMult
            }
        }

        Column {
            anchors.horizontalCenter: parent.right
            anchors.top: parent.verticalCenter
            anchors.horizontalCenterOffset: -res.thickness / 2
            anchors.topMargin: res.thickness / 2 + Appearance.spacing.small

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.label2
                font.pointSize: Appearance.font.size.smaller * res.primaryMult
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.sublabel2
                color: ComponentColors.region.dashboard.performance.resource.sublabel
                font.pointSize: Appearance.font.size.small * res.primaryMult
            }
        }

        Shape {
            id: shapeRoot
            anchors.fill: parent
            antialiasing: true

            readonly property real radius: (Math.min(width, height) - res.thickness) / 2
            readonly property real cx: width / 2
            readonly property real cy: height / 2

            ShapePath {
                strokeColor: res.bg1
                strokeWidth: res.thickness
                fillColor: "transparent"
                capStyle: Appearance.rounding.scale === 0 ? ShapePath.FlatCap : ShapePath.RoundCap

                startX: shapeRoot.cx + shapeRoot.radius * Math.cos(Math.PI / 4)
                startY: shapeRoot.cy + shapeRoot.radius * Math.sin(Math.PI / 4)
                PathAngleArc {
                    centerX: shapeRoot.cx
                    centerY: shapeRoot.cy
                    radiusX: shapeRoot.radius
                    radiusY: shapeRoot.radius
                    startAngle: 45
                    sweepAngle: 175
                }
            }

            ShapePath {
                strokeColor: res.fg1
                strokeWidth: res.thickness
                fillColor: "transparent"
                capStyle: Appearance.rounding.scale === 0 ? ShapePath.FlatCap : ShapePath.RoundCap

                startX: shapeRoot.cx + shapeRoot.radius * Math.cos(Math.PI / 4)
                startY: shapeRoot.cy + shapeRoot.radius * Math.sin(Math.PI / 4)
                PathAngleArc {
                    centerX: shapeRoot.cx
                    centerY: shapeRoot.cy
                    radiusX: shapeRoot.radius
                    radiusY: shapeRoot.radius
                    startAngle: 45
                    sweepAngle: 175 * res.value1
                }
            }

            ShapePath {
                strokeColor: res.bg2
                strokeWidth: res.thickness
                fillColor: "transparent"
                capStyle: Appearance.rounding.scale === 0 ? ShapePath.FlatCap : ShapePath.RoundCap

                startX: shapeRoot.cx + shapeRoot.radius * Math.cos(230 * Math.PI / 180)
                startY: shapeRoot.cy + shapeRoot.radius * Math.sin(230 * Math.PI / 180)
                PathAngleArc {
                    centerX: shapeRoot.cx
                    centerY: shapeRoot.cy
                    radiusX: shapeRoot.radius
                    radiusY: shapeRoot.radius
                    startAngle: 230
                    sweepAngle: 130
                }
            }

            ShapePath {
                strokeColor: res.fg2
                strokeWidth: res.thickness
                fillColor: "transparent"
                capStyle: Appearance.rounding.scale === 0 ? ShapePath.FlatCap : ShapePath.RoundCap

                startX: shapeRoot.cx + shapeRoot.radius * Math.cos(230 * Math.PI / 180)
                startY: shapeRoot.cy + shapeRoot.radius * Math.sin(230 * Math.PI / 180)
                PathAngleArc {
                    centerX: shapeRoot.cx
                    centerY: shapeRoot.cy
                    radiusX: shapeRoot.radius
                    radiusY: shapeRoot.radius
                    startAngle: 230
                    sweepAngle: 130 * res.value2
                }
            }
        }

        Behavior on value1 {
            Anim {}
        }

        Behavior on value2 {
            Anim {}
        }

        Behavior on fg1 {
            CAnim {}
        }

        Behavior on fg2 {
            CAnim {}
        }

        Behavior on bg1 {
            CAnim {}
        }

        Behavior on bg2 {
            CAnim {}
        }
    }
}
