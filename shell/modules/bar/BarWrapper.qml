pragma ComponentBehavior: Bound

import qs.components
import qs.config
import qs.services
import "popouts" as BarPopouts
import Quickshell
import QtQuick

Item {
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property BarPopouts.Wrapper popouts
    required property bool disabled

    readonly property int padding: Math.max(Appearance.padding.smaller, Config.border.thickness)
    readonly property int contentWidth: Config.bar.sizes.innerWidth + padding * 2

    // "hideOnEmpty" mode: detect if current workspace has no windows
    readonly property var _mon: Hypr.monitorFor(screen)
    readonly property int _activeWsId: _mon?.activeWorkspace?.id ?? -1
    readonly property var _activeWs: _activeWsId >= 0 ? Hypr.workspaces.values.find(w => w.id === _activeWsId) : null
    readonly property bool _desktopEmpty: !_activeWs || (_activeWs.lastIpcObject.windows ?? 0) === 0

    readonly property bool modeVisible: {
        const m = Config.bar.mode;
        if (m === "persistent") return true;
        if (m === "hideOnEmpty") return !_desktopEmpty;
        return false; // "autoHide"
    }

    readonly property int exclusiveZone: !disabled && (modeVisible || visibilities.bar) ? contentWidth : Config.border.thickness
    readonly property bool shouldBeVisible: !disabled && (modeVisible || visibilities.bar || isHovered)
    property bool isHovered

    function closeTray(): void {
        content.item?.closeTray();
    }

    function checkPopout(y: real): void {
        content.item?.checkPopout(y);
    }

    function handleWheel(y: real, angleDelta: point): void {
        content.item?.handleWheel(y, angleDelta);
    }

    visible: width > Config.border.thickness
    implicitWidth: Config.border.thickness

    states: State {
        name: "visible"
        when: root.shouldBeVisible

        PropertyChanges {
            root.implicitWidth: root.contentWidth
            content.opacity: 1
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            // Show: snap content visible instantly, then expand width
            PropertyAction {
                target: content
                property: "opacity"
            }
            Anim {
                target: root
                property: "implicitWidth"
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        },
        Transition {
            from: "visible"
            to: ""

            // Hide: fade out content quickly, then collapse width
            SequentialAnimation {
                Anim {
                    target: content
                    property: "opacity"
                    duration: 50
                    easing.bezierCurve: Appearance.anim.curves.standard
                }
                Anim {
                    target: root
                    property: "implicitWidth"
                    easing.bezierCurve: Appearance.anim.curves.emphasized
                }
            }
        }
    ]

    Loader {
        id: content

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        active: root.shouldBeVisible || root.visible
        opacity: 0

        sourceComponent: Bar {
            width: root.contentWidth
            screen: root.screen
            visibilities: root.visibilities
            popouts: root.popouts
        }
    }
}
