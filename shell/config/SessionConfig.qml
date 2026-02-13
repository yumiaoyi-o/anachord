import Quickshell.Io

JsonObject {
    property bool enabled: true
    property Commands commands: Commands {}

    component Commands: JsonObject {
        property list<string> shutdown: ["systemctl", "poweroff"]
        property list<string> reboot: ["systemctl", "reboot"]
    }
}
