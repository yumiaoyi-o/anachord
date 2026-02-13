pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import qs.utils
import Anachord
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

MouseArea {
    id: root

    required property LazyLoader loader
    required property ShellScreen screen

    property real realBorderWidth: 2

    property real sx: 0
    property real sy: 0
    property real ex: 0
    property real ey: 0

    property bool hasDragged: false

    property real rsx: Math.min(sx, ex)
    property real rsy: Math.min(sy, ey)
    property real sw: Math.abs(sx - ex)
    property real sh: Math.abs(sy - ey)

    function save(): void {
        const now = new Date();
        const ts = now.getFullYear().toString()
            + (now.getMonth() + 1).toString().padStart(2, "0")
            + now.getDate().toString().padStart(2, "0")
            + "_"
            + now.getHours().toString().padStart(2, "0")
            + "-" + now.getMinutes().toString().padStart(2, "0")
            + "-" + now.getSeconds().toString().padStart(2, "0");
        const destDir = Paths.screenshotsdir;
        const destFile = Qt.resolvedUrl(`${destDir}/screenshot_${ts}.png`);
        const tmpfile = Qt.resolvedUrl(`/tmp/anachord-picker-${Quickshell.processId}-${Date.now()}.png`);
        CUtils.saveItem(screencopy, tmpfile, Qt.rect(Math.ceil(rsx), Math.ceil(rsy), Math.floor(sw), Math.floor(sh)), path => {
            Quickshell.execDetached(["sh", "-c", `mkdir -p '${destDir}' && cp '${path}' '${CUtils.toLocalFile(destFile)}' && wl-copy --type image/png < '${path}'`]);
            Quickshell.execDetached(["notify-send", "-a", "anachord-cli", "-i", "image-x-generic-symbolic", "Screenshot saved", `Saved to ${CUtils.toLocalFile(destFile)}`]);
        });
        closeAnim.start();
    }

    anchors.fill: parent
    opacity: 0
    hoverEnabled: true
    cursorShape: Qt.CrossCursor

    Component.onCompleted: {
        opacity = 1;
    }

    onPressed: event => {
        sx = event.x;
        sy = event.y;
        ex = event.x;
        ey = event.y;
        hasDragged = false;
    }

    onReleased: {
        if (closeAnim.running)
            return;

        if (!hasDragged || sw < 5 || sh < 5) {
            closeAnim.start();
            return;
        }

        if (root.loader.freeze) {
            save();
        } else {
            overlay.visible = border.visible = false;
            screencopy.visible = false;
            screencopy.active = true;
        }
    }

    onPositionChanged: event => {
        if (pressed) {
            hasDragged = true;
            ex = event.x;
            ey = event.y;
        }
    }

    focus: true
    Keys.onEscapePressed: closeAnim.start()

    SequentialAnimation {
        id: closeAnim

        PropertyAction {
            target: root.loader
            property: "closing"
            value: true
        }
        ParallelAnimation {
            Anim {
                target: root
                property: "opacity"
                to: 0
                duration: Appearance.anim.durations.large
            }
            ExAnim {
                target: root
                properties: "rsx,rsy"
                to: 0
            }
            ExAnim {
                target: root
                property: "sw"
                to: root.screen.width
            }
            ExAnim {
                target: root
                property: "sh"
                to: root.screen.height
            }
        }
        PropertyAction {
            target: root.loader
            property: "activeAsync"
            value: false
        }
    }

    Loader {
        id: screencopy

        anchors.fill: parent

        active: root.loader.freeze

        sourceComponent: ScreencopyView {
            captureSource: root.screen

            onHasContentChanged: {
                if (hasContent && !root.loader.freeze) {
                    overlay.visible = border.visible = true;
                    root.save();
                }
            }
        }
    }

    StyledRect {
        id: overlay

        anchors.fill: parent
        color: ComponentColors.region.bar.popout.button.bg
        opacity: 0.3

        layer.enabled: true
        layer.effect: MultiEffect {
            maskSource: selectionWrapper
            maskEnabled: true
            maskInverted: true
            maskSpreadAtMin: 1
            maskThresholdMin: 0.5
        }
    }

    Item {
        id: selectionWrapper

        anchors.fill: parent
        layer.enabled: true
        visible: false

        Rectangle {
            id: selectionRect

            x: root.rsx
            y: root.rsy
            implicitWidth: root.sw
            implicitHeight: root.sh
        }
    }

    Rectangle {
        id: border

        color: "transparent"
        border.width: root.realBorderWidth
        border.color: ComponentColors.region.bar.accent

        x: selectionRect.x - root.realBorderWidth
        y: selectionRect.y - root.realBorderWidth
        implicitWidth: selectionRect.implicitWidth + root.realBorderWidth * 2
        implicitHeight: selectionRect.implicitHeight + root.realBorderWidth * 2

        Behavior on border.color {
            CAnim {}
        }
    }

    Behavior on opacity {
        Anim {
            duration: Appearance.anim.durations.large
        }
    }

    Behavior on rsx {
        enabled: !root.pressed

        ExAnim {}
    }

    Behavior on rsy {
        enabled: !root.pressed

        ExAnim {}
    }

    Behavior on sw {
        enabled: !root.pressed

        ExAnim {}
    }

    Behavior on sh {
        enabled: !root.pressed

        ExAnim {}
    }

    component ExAnim: Anim {
        duration: Appearance.anim.durations.expressiveDefaultSpatial
        easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
    }
}
