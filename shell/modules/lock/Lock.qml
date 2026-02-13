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

    // ── Normal session lock mode ──
    WlSessionLock {
        id: lock

        signal unlock

        LockSurface {
            lock: lock
            pam: pam
        }
    }

    // ── Greeter mode (full-screen layer shell) ──
    Loader {
        active: root.greeterMode

        sourceComponent: GreeterSurface {
            pam: pam
        }
    }

    Pam {
        id: pam

        lock: lock
    }

    // Lock shortcuts (only meaningful in session lock mode)
    CustomShortcut {
        name: "lock"
        description: "Lock the current session"
        onPressed: {
            if (!root.greeterMode)
                lock.locked = true;
        }
    }

    CustomShortcut {
        name: "unlock"
        description: "Unlock the current session"
        onPressed: {
            if (!root.greeterMode)
                lock.unlock();
        }
    }

    IpcHandler {
        target: "lock"

        function lock(): void {
            if (!root.greeterMode)
                lock.locked = true;
        }

        function unlock(): void {
            if (!root.greeterMode)
                lock.unlock();
        }

        function isLocked(): bool {
            return root.greeterMode || lock.locked;
        }
    }

    // In greeter mode, auto-lock on startup so the lock surface
    // is always visible (for normal lock mode, not greeter)
    Component.onCompleted: {
        if (!greeterMode) {
            // Normal mode: nothing special on startup
        }
        // Greeter mode: GreeterSurface is already shown via Loader
    }
}
