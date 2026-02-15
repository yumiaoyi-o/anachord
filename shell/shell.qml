//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import "modules"
import "modules/drawers"
import "modules/background"
import "modules/areapicker"
import "modules/lock"
import Quickshell
import Quickshell.Services.Greetd
import QtQuick

ShellRoot {
    id: shellRoot

    readonly property bool greeterMode: Greetd.available

    Lock {
        id: lock
    }

    // In greeter mode, skip all desktop components — only Lock is needed
    Loader {
        active: !shellRoot.greeterMode
        source: "modules/background/Background.qml"
    }
    Loader {
        id: drawersLoader

        active: !shellRoot.greeterMode

        onActiveChanged: {
            if (active)
                setSource("modules/drawers/Drawers.qml", { lock: lock.lock });
        }

        Component.onCompleted: {
            if (active)
                setSource("modules/drawers/Drawers.qml", { lock: lock.lock });
        }
    }
    Loader {
        active: !shellRoot.greeterMode
        source: "modules/areapicker/AreaPicker.qml"
    }
    Loader {
        active: !shellRoot.greeterMode
        source: "modules/Shortcuts.qml"
    }
    Loader {
        active: !shellRoot.greeterMode
        source: "modules/BatteryMonitor.qml"
    }
    Loader {
        id: idleLoader
        active: !shellRoot.greeterMode
        onActiveChanged: {
            if (active)
                setSource("modules/IdleMonitors.qml", { lock: lock });
        }
        Component.onCompleted: {
            if (active)
                setSource("modules/IdleMonitors.qml", { lock: lock });
        }
    }
}
