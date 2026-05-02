import qs.config
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Services.Greetd
import QtQuick

Scope {
    id: root

    required property WlSessionLock lock

    // ── Public interface (unchanged for Center.qml compatibility) ──
    readonly property alias passwd: passwd
    readonly property alias fprint: fprint
    property string lockMessage
    property string state
    property string fprintState
    property string buffer

    // Whether we are running as a greetd greeter (login) vs session lock
    readonly property bool greeterMode: Greetd.available

    // Unified "authenticating" flag for UI (works in both modes)
    readonly property bool authenticating: greeterMode ? _greetdAuthActive : passwd.active

    // Unified auth message for UI
    readonly property string authMessage: greeterMode ? _greetdMessage : passwd.message

    // Unified start-auth function for submit button
    function startAuth(): void {
        if (!buffer) return;
        if (greeterMode) {
            if (Greetd.state == 0) { // Inactive
                const user = Quickshell.env("USER") ?? "yumiaoyi";
                Greetd.createSession(user);
                greetdWaitingForSession = true;
            } else if (Greetd.state == 1) { // Authenticating
                Greetd.respond(buffer);
                buffer = "";
                _greetdAuthActive = true;
                pamTimeout.restart();
            }
        } else {
            passwd.start();
            pamTimeout.restart();
        }
    }

    property bool _greetdAuthActive: false
    property string _greetdMessage: ""
    property bool _greetdLaunched: false

    signal flashMsg

    function handleKey(event: KeyEvent): void {
        if (authenticating || state === "max")
            return;

        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            if (!buffer)
                return;
            startAuth();
        } else if (event.key === Qt.Key_Backspace) {
            if (event.modifiers & Qt.ControlModifier) {
                buffer = "";
            } else {
                buffer = buffer.slice(0, -1);
            }
        } else if (" abcdefghijklmnopqrstuvwxyz1234567890`~!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?".includes(event.text.toLowerCase())) {
            buffer += event.text;
        }
    }

    // ── greetd greeter mode ──
    property bool greetdWaitingForSession: false

    Connections {
        enabled: root.greeterMode
        target: Greetd

        function onAuthMessage(message: string, error: bool, responseRequired: bool, echoResponse: bool): void {
            if (error) {
                root._greetdMessage = message;
                root.state = "error";
                root.flashMsg();
                stateReset.restart();
                root._greetdAuthActive = false;
                root.greetdWaitingForSession = false;
                return;
            }

            if (responseRequired) {
                if (root.greetdWaitingForSession && root.buffer.length > 0) {
                    root.greetdWaitingForSession = false;
                    Greetd.respond(root.buffer);
                    root.buffer = "";
                    root._greetdAuthActive = true;
                    pamTimeout.restart();
                } else if (root.greetdWaitingForSession) {
                    root.greetdWaitingForSession = false;
                    Greetd.respond("");
                    root._greetdAuthActive = true;
                    pamTimeout.restart();
                } else {
                    Greetd.respond("");
                }
            }
        }

        function onReadyToLaunch(): void {
            if (!root._greetdLaunched) {
                root._greetdLaunched = true;
                pamTimeout.stop();
                root._greetdAuthActive = false;
                Greetd.launch(["/etc/greetd/start-user-session"]);
                _exitSafetyTimer.start();
            }
        }

        function onLaunched(): void {
            Qt.quit();
        }

        function onStateChanged(): void {
            if (Greetd.state == 2) { // ReadyToLaunch
                if (!root._greetdLaunched) {
                    root._greetdLaunched = true;
                    pamTimeout.stop();
                    root._greetdAuthActive = false;
                    Greetd.launch(["/etc/greetd/start-user-session"]);
                    _exitSafetyTimer.start();
                }
            } else if (Greetd.state == 4) { // Launched
                Qt.quit();
            }
        }

        function onAuthFailure(message: string): void {
            pamTimeout.stop();
            root._greetdAuthActive = false;
            root._greetdMessage = message || "认证失败";
            root.state = "fail";
            root.flashMsg();
            stateReset.restart();
        }

        function onError(error: string): void {
            pamTimeout.stop();
            root._greetdAuthActive = false;
            root._greetdMessage = error;
            root.state = "error";
            root.flashMsg();
            stateReset.restart();
        }
    }

    // ── PAM lock mode (original) ──

    PamContext {
        id: passwd

        config: "passwd"
        configDirectory: Quickshell.shellDir + "/assets/pam.d"

        onMessageChanged: {
            if (message.startsWith("The account is locked"))
                root.lockMessage = message;
            else if (root.lockMessage && message.endsWith(" left to unlock)"))
                root.lockMessage += "\n" + message;
        }

        onResponseRequiredChanged: {
            if (!responseRequired)
                return;

            respond(root.buffer);
            root.buffer = "";
        }

        onCompleted: res => {
            pamTimeout.stop();

            if (res === PamResult.Success)
                return root.lock.unlock();

            if (res === PamResult.Error)
                root.state = "error";
            else if (res === PamResult.MaxTries)
                root.state = "max";
            else if (res === PamResult.Failed)
                root.state = "fail";

            root.flashMsg();
            stateReset.restart();
        }
    }

    PamContext {
        id: fprint

        property bool available
        property int tries
        property int errorTries

        function checkAvail(): void {
            if (!available || !Config.lock.enableFprint || !root.lock.secure) {
                abort();
                return;
            }

            tries = 0;
            errorTries = 0;
            start();
        }

        config: "fprint"
        configDirectory: Quickshell.shellDir + "/assets/pam.d"

        onCompleted: res => {
            if (!available)
                return;

            if (res === PamResult.Success)
                return root.lock.unlock();

            if (res === PamResult.Error) {
                root.fprintState = "error";
                errorTries++;
                if (errorTries < 5) {
                    abort();
                    errorRetry.restart();
                }
            } else if (res === PamResult.MaxTries) {
                tries++;
                if (tries < Config.lock.maxFprintTries) {
                    root.fprintState = "fail";
                    start();
                } else {
                    root.fprintState = "max";
                    abort();
                }
            }

            root.flashMsg();
            fprintStateReset.start();
        }
    }

    Process {
        id: availProc

        command: ["sh", "-c", "fprintd-list $USER"]
        onExited: code => {
            fprint.available = code === 0;
            fprint.checkAvail();
        }
    }

    Timer {
        id: pamTimeout

        interval: 15000
        onTriggered: {
            if (root.greeterMode) {
                Greetd.cancelSession();
                root._greetdAuthActive = false;
            } else {
                passwd.abort();
            }
            root.state = "error";
            root.flashMsg();
            stateReset.restart();
        }
    }

    Timer {
        id: errorRetry

        interval: 800
        onTriggered: fprint.start()
    }

    // Safety timer: force-quit if Greetd.launch() succeeded but quickshell didn't exit
    Timer {
        id: _exitSafetyTimer

        interval: 3000
        onTriggered: {
            Qt.quit();
        }
    }

    Timer {
        id: stateReset

        interval: 4000
        onTriggered: {
            if (root.state !== "max")
                root.state = "";
            root._greetdMessage = "";
        }
    }

    Timer {
        id: fprintStateReset

        interval: 4000
        onTriggered: {
            root.fprintState = "";
            fprint.errorTries = 0;
        }
    }

    Connections {
        target: root.lock

        function onSecureChanged(): void {
            if (root.lock.secure) {
                availProc.running = true;
                root.buffer = "";
                root.state = "";
                root.fprintState = "";
                root.lockMessage = "";
                root._greetdAuthActive = false;
                root._greetdMessage = "";
            }
        }

        function onUnlock(): void {
            fprint.abort();
        }
    }

    Connections {
        target: Config.lock

        function onEnableFprintChanged(): void {
            fprint.checkAvail();
        }
    }
}
