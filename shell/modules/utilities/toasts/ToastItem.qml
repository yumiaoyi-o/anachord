import qs.components
import qs.components.effects
import qs.services
import qs.config
import Anachord
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root

    required property Toast modelData

    anchors.left: parent.left
    anchors.right: parent.right
    implicitHeight: layout.implicitHeight + Appearance.padding.smaller * 2

    radius: Appearance.rounding.normal
    color: {
        if (root.modelData.type === Toast.Success)
            return ComponentColors.region.state.successContainer;
        if (root.modelData.type === Toast.Warning)
            return ComponentColors.region.utilities.toast.warningBg;
        if (root.modelData.type === Toast.Error)
            return ComponentColors.region.state.errorContainer;
        return ComponentColors.region.utilities.toast.defaultBg;
    }

    border.width: 1
    border.color: {
        let colour = ComponentColors.region.utilities.toast.defaultBorder;
        if (root.modelData.type === Toast.Success)
            colour = ComponentColors.region.state.success;
        if (root.modelData.type === Toast.Warning)
            colour = ComponentColors.region.utilities.toast.warningBorder;
        if (root.modelData.type === Toast.Error)
            colour = ComponentColors.region.state.error;
        return Qt.alpha(colour, 0.3);
    }

    Elevation {
        anchors.fill: parent
        radius: parent.radius
        opacity: parent.opacity
        z: -1
        level: 3
    }

    RowLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: Appearance.padding.smaller
        anchors.leftMargin: Appearance.padding.normal
        anchors.rightMargin: Appearance.padding.normal
        spacing: Appearance.spacing.normal

        StyledRect {
            radius: Appearance.rounding.normal
            color: {
                if (root.modelData.type === Toast.Success)
                    return ComponentColors.region.state.success;
                if (root.modelData.type === Toast.Warning)
                    return ComponentColors.region.utilities.toast.warningIconBg;
                if (root.modelData.type === Toast.Error)
                    return ComponentColors.region.state.error;
                return ComponentColors.region.utilities.toast.defaultIconBg;
            }

            implicitWidth: implicitHeight
            implicitHeight: icon.implicitHeight + Appearance.padding.smaller * 2

            MaterialIcon {
                id: icon

                anchors.centerIn: parent
                text: root.modelData.icon
                color: {
                    if (root.modelData.type === Toast.Success)
                        return ComponentColors.region.state.onSuccess;
                    if (root.modelData.type === Toast.Warning)
                        return ComponentColors.region.utilities.toast.warningIconFg;
                    if (root.modelData.type === Toast.Error)
                        return ComponentColors.region.state.onError;
                    return ComponentColors.region.utilities.toast.defaultIconFg;
                }
                font.pointSize: Math.round(Appearance.font.size.large * 1.2)
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            StyledText {
                id: title

                Layout.fillWidth: true
                text: root.modelData.title
                color: {
                    if (root.modelData.type === Toast.Success)
                        return ComponentColors.region.state.onSuccessContainer;
                    if (root.modelData.type === Toast.Warning)
                        return ComponentColors.region.utilities.toast.warningTitle;
                    if (root.modelData.type === Toast.Error)
                        return ComponentColors.region.state.onErrorContainer;
                    return ComponentColors.region.utilities.toast.defaultTitle;
                }
                font.pointSize: Appearance.font.size.normal
                elide: Text.ElideRight
            }

            StyledText {
                Layout.fillWidth: true
                textFormat: Text.StyledText
                text: root.modelData.message
                color: {
                    if (root.modelData.type === Toast.Success)
                        return ComponentColors.region.state.onSuccessContainer;
                    if (root.modelData.type === Toast.Warning)
                        return ComponentColors.region.utilities.toast.warningBody;
                    if (root.modelData.type === Toast.Error)
                        return ComponentColors.region.state.onErrorContainer;
                    return ComponentColors.region.utilities.toast.defaultBody;
                }
                opacity: 0.8
                elide: Text.ElideRight
            }
        }
    }

    Behavior on border.color {
        CAnim {}
    }
}
