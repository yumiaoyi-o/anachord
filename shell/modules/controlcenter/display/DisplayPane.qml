pragma ComponentBehavior: Bound

import ".."
import "../components"
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import qs.utils
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Session session

    function resolveLockTimeout(): int {
        const legacyTimeout = Config.display?.lockTimeout;
        if (legacyTimeout === 0)
            return 0;

        const timeouts = Config.general?.idle?.timeouts ?? [];
        for (const entry of timeouts) {
            if ((entry?.idleAction ?? "") === "lock")
                return entry?.timeout ?? 300;
        }
        return legacyTimeout ?? 300;
    }

    readonly property var monitor: session.root ? Brightness.getMonitorForScreen(session.root.screen) : null
    property real screenBrightness: monitor?.brightness ?? 0
    property int lockTimeout: resolveLockTimeout()
    property string screenshotsDir: Config.paths?.screenshotsDir ?? `${Paths.pictures}/Screenshots`
    property string recordingsDir: Config.paths?.recordingsDir ?? `${Paths.videos}/Recordings`

    anchors.fill: parent

    Connections {
        target: root.monitor
        enabled: root.monitor !== null

        function onBrightnessChanged(): void {
            root.screenBrightness = root.monitor?.brightness ?? 0;
        }
    }

    function saveConfig(): void {
        Config.display.lockTimeout = root.lockTimeout;
        Config.paths.screenshotsDir = root.screenshotsDir;
        Config.paths.recordingsDir = root.recordingsDir;

        const originalTimeouts = Config.general?.idle?.timeouts ?? [];
        const timeouts = originalTimeouts.slice();
        let lockIndex = -1;

        for (let i = 0; i < timeouts.length; i++) {
            if ((timeouts[i]?.idleAction ?? "") === "lock") {
                lockIndex = i;
                break;
            }
        }

        if (root.lockTimeout === 0) {
            if (lockIndex >= 0)
                timeouts.splice(lockIndex, 1);
        } else {
            const lockEntry = {
                timeout: root.lockTimeout,
                idleAction: "lock"
            };
            if (lockIndex >= 0)
                timeouts[lockIndex] = Object.assign({}, timeouts[lockIndex], lockEntry);
            else
                timeouts.unshift(lockEntry);
        }

        Config.general.idle.timeouts = timeouts;
        IdleInhibitor.enabled = (root.lockTimeout === 0);
        Config.save();
    }

    StyledFlickable {
        id: flickable

        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        flickableDirection: Flickable.VerticalFlick
        contentHeight: layout.height

        StyledScrollBar.vertical: StyledScrollBar {
            flickable: flickable
        }

        ColumnLayout {
            id: layout

            anchors.left: parent.left
            anchors.right: parent.right
            spacing: Appearance.spacing.large

            StyledText {
                text: qsTr("Display")
                font.pointSize: Appearance.font.size.large
                font.weight: 500
            }

            // === Brightness ===
            SectionContainer {
                visible: root.monitor !== null
                contentSpacing: Appearance.spacing.normal

                SliderInput {
                    Layout.fillWidth: true

                    label: qsTr("Brightness")
                    value: root.screenBrightness * 100
                    from: 0
                    to: 100
                    suffix: "%"
                    validator: IntValidator {
                        bottom: 0
                        top: 100
                    }
                    formatValueFunction: val => Math.round(val).toString()
                    parseValueFunction: text => parseInt(text)

                    onValueModified: newValue => {
                        root.screenBrightness = newValue / 100;
                        root.monitor?.setBrightness(root.screenBrightness);
                    }
                }
            }

            SectionContainer {
                visible: root.monitor === null

                StyledText {
                    text: qsTr("No controllable display detected")
                    color: ComponentColors.region.panel.subtext
                }
            }

            // === Lock Timeout ===
            SectionContainer {
                contentSpacing: Appearance.spacing.normal

                StyledText {
                    text: qsTr("Auto-lock after")
                    font.pointSize: Appearance.font.size.normal
                    font.weight: 500
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Appearance.spacing.small

                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("5 minutes")
                        checked: root.lockTimeout === 300
                        onClicked: { root.lockTimeout = 300; root.saveConfig(); }
                    }
                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("10 minutes")
                        checked: root.lockTimeout === 600
                        onClicked: { root.lockTimeout = 600; root.saveConfig(); }
                    }
                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("15 minutes")
                        checked: root.lockTimeout === 900
                        onClicked: { root.lockTimeout = 900; root.saveConfig(); }
                    }
                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("30 minutes")
                        checked: root.lockTimeout === 1800
                        onClicked: { root.lockTimeout = 1800; root.saveConfig(); }
                    }
                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("1 hour")
                        checked: root.lockTimeout === 3600
                        onClicked: { root.lockTimeout = 3600; root.saveConfig(); }
                    }
                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("2 hours")
                        checked: root.lockTimeout === 7200
                        onClicked: { root.lockTimeout = 7200; root.saveConfig(); }
                    }
                    StyledRadioButton {
                        Layout.fillWidth: true
                        text: qsTr("Never")
                        checked: root.lockTimeout === 0
                        onClicked: { root.lockTimeout = 0; root.saveConfig(); }
                    }
                }
            }

            // === Storage Paths ===
            StyledText {
                text: qsTr("Storage")
                font.pointSize: Appearance.font.size.large
                font.weight: 500
            }

            SectionContainer {
                contentSpacing: Appearance.spacing.normal

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Appearance.spacing.small

                    StyledText {
                        text: qsTr("Screenshots")
                        font.pointSize: Appearance.font.size.small
                        color: ComponentColors.region.panel.subtext
                    }

                    StyledRect {
                        Layout.fillWidth: true
                        implicitHeight: ssPathField.implicitHeight + Appearance.padding.smaller * 2
                        radius: Appearance.rounding.small
                        color: ComponentColors.region.panel.surfaceHigh

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Appearance.padding.normal
                            anchors.rightMargin: Appearance.padding.small
                            spacing: Appearance.spacing.small

                            StyledTextField {
                                id: ssPathField

                                Layout.fillWidth: true
                                text: Paths.shortenHome(root.screenshotsDir)
                                color: ComponentColors.region.panel.text
                                font.pointSize: Appearance.font.size.small

                                onEditingFinished: {
                                    root.screenshotsDir = Paths.absolutePath(text);
                                    root.saveConfig();
                                }
                            }

                            IconButton {
                                icon: "folder_open"
                                type: IconButton.Text
                                font.pointSize: Appearance.font.size.normal
                                onClicked: {
                                    root.screenshotsDir = Paths.absolutePath(ssPathField.text);
                                    root.saveConfig();
                                }
                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Appearance.spacing.small

                    StyledText {
                        text: qsTr("Recordings")
                        font.pointSize: Appearance.font.size.small
                        color: ComponentColors.region.panel.subtext
                    }

                    StyledRect {
                        Layout.fillWidth: true
                        implicitHeight: recPathField.implicitHeight + Appearance.padding.smaller * 2
                        radius: Appearance.rounding.small
                        color: ComponentColors.region.panel.surfaceHigh

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Appearance.padding.normal
                            anchors.rightMargin: Appearance.padding.small
                            spacing: Appearance.spacing.small

                            StyledTextField {
                                id: recPathField

                                Layout.fillWidth: true
                                text: Paths.shortenHome(root.recordingsDir)
                                color: ComponentColors.region.panel.text
                                font.pointSize: Appearance.font.size.small

                                onEditingFinished: {
                                    root.recordingsDir = Paths.absolutePath(text);
                                    root.saveConfig();
                                }
                            }

                            IconButton {
                                icon: "folder_open"
                                type: IconButton.Text
                                font.pointSize: Appearance.font.size.normal
                                onClicked: {
                                    root.recordingsDir = Paths.absolutePath(recPathField.text);
                                    root.saveConfig();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
