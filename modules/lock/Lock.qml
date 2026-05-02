pragma ComponentBehavior: Bound

import qs.components.misc
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Greetd
import QtQuick

Scope {
    id: root

    property alias lock: lock
    readonly property bool greeterMode: Greetd.available

    // Fallback lock flag — bypasses WlSessionLock (which crashes in native code)
    // and reuses GreeterSurface's PanelWindow overlay instead.
    property bool fallbackLocked: false
    readonly property bool isLocked: root.greeterMode || root.fallbackLocked || lock.locked

    // WlSessionLock kept but never activated; its unlock signal is still used
    // by Pam.qml to signal successful authentication.
    WlSessionLock {
        id: lock

        signal unlock

        LockSurface {
            lock: lock
            pam: pam
        }
    }

    // GreeterSurface shown in greeter mode OR as fallback session lock
    Loader {
        active: root.greeterMode || root.fallbackLocked

        sourceComponent: GreeterSurface {
            pam: pam
        }
    }

    Pam {
        id: pam
        lock: lock
    }

    // When PAM succeeds → Pam calls lock.unlock() → dismiss fallback surface
    Connections {
        target: lock

        function onUnlock(): void {
            root.fallbackLocked = false;
        }
    }

    CustomShortcut {
        name: "lock"
        description: "Lock the current session"
        onPressed: {
            if (!root.greeterMode)
                root.fallbackLocked = true;
        }
    }

    CustomShortcut {
        name: "unlock"
        description: "Unlock the current session"
        onPressed: {
            if (!root.greeterMode)
                root.fallbackLocked = false;
        }
    }

    IpcHandler {
        target: "lock"

        function lock(): void {
            if (!root.greeterMode)
                root.fallbackLocked = true;
        }

        function unlock(): void {
            if (!root.greeterMode)
                root.fallbackLocked = false;
        }

        function isLocked(): bool {
            return root.greeterMode || root.fallbackLocked;
        }
    }
}
