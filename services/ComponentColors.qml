pragma Singleton
pragma ComponentBehavior: Bound

import qs.config
import qs.utils
import qs.services
import Anachord
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // ═══════════════════════════════════════════════════════════
    // Accent Colors
    // ═══════════════════════════════════════════════════════════
    property color accentPrimary: "#AF2828"
    property color accentSecondary: "#C85050"
    property color accentTertiary: "#D47070"
    property color fgAccentPrimary: "#FFFFFF"
    property color fgAccentSecondary: "#ffffff"
    property color fgAccentTertiary: "#ffffff"

    property color accentContainer: "#FADED8"
    property color fgAccentContainer: "#731515"
    property color inversePrimary: "#E89E9E"
    property color tertiaryContainer: "#D47070"
    property color fgTertiaryContainer: "#ffffff"
    // ═══════════════════════════════════════════════════════════
    // Text Colors
    // ═══════════════════════════════════════════════════════════
    property color textPrimary: "#1c1c1c"
    property color textSecondary: "#474747"
    property color textDisabled: "#747474"
    property color textOnAccent: "#FFFFFF"

    // ═══════════════════════════════════════════════════════════
    // Surface / Background Colors
    // ═══════════════════════════════════════════════════════════
    property color surfaceBase: "#fafafa"
    property color surfaceDim: "#dadada"
    property color surfaceBright: "#fafafa"
    property color surfaceContainer: "#eeeeee"
    property color surfaceContainerLow: "#f4f4f4"
    property color surfaceContainerHigh: "#e8e8e8"
    property color surfaceContainerHighest: "#e3e3e3"
    property color background: "#fafafa"
    property color fgBackground: "#1c1c1c"

    // ═══════════════════════════════════════════════════════════
    // Bar (Status Bar)
    // ═══════════════════════════════════════════════════════════
    property color barBackground: "#fafafa"
    property color barText: "#1c1c1c"
    property color barIcon: "#474747"
    property color barActiveIndicator: "#AF2828"
    property color barActiveText: "#FFFFFF"
    property color barBadge: "#af2f28"

    // ═══════════════════════════════════════════════════════════
    // Media Lines
    // ═══════════════════════════════════════════════════════════
    property color mediaLinesPrimary: "#AF2828"
    property color mediaLinesSecondary: "#C85050"
    property color mediaLinesTertiary: "#D47070"

    // ═══════════════════════════════════════════════════════════
    // Launcher
    // ═══════════════════════════════════════════════════════════
    property color launcherBackground: "#fafafa"
    property color launcherSearchBg: "#eeeeee"
    property color launcherSearchText: "#1c1c1c"
    property color launcherItemText: "#1c1c1c"
    property color launcherItemSubtext: "#747474"
    property color launcherItemHover: "#F5E8E7"

    // ═══════════════════════════════════════════════════════════
    // Panel (Control Center / Sidebars)
    // ═══════════════════════════════════════════════════════════
    property color panelBackground: "#fafafa"
    property color panelSurface: "#eeeeee"
    property color panelSurfaceHigh: "#e8e8e8"
    property color panelText: "#1c1c1c"
    property color panelSubtext: "#474747"
    property color panelBorder: "#747474"
    property color panelDivider: "#c7c7c7"

    // ═══════════════════════════════════════════════════════════
    // Controls (Buttons, Switches, Sliders)
    // ═══════════════════════════════════════════════════════════
    property color buttonFilledBg: "#AF2828"
    property color buttonFilledText: "#FFFFFF"
    property color buttonTonalBg: "#F5E8E7"
    property color buttonTonalText: "#8C2020"
    property color buttonOutlineBorder: "#747474"
    property color switchActive: "#AF2828"
    property color switchInactive: "#e3e3e3"
    property color sliderTrack: "#AF2828"
    property color sliderInactive: "#e3e3e3"

    // ═══════════════════════════════════════════════════════════
    // Notifications
    // ═══════════════════════════════════════════════════════════
    property color notifBackground: "#fafafa"
    property color notifText: "#1c1c1c"
    property color notifSubtext: "#474747"
    property color notifActionBg: "#F5E8E7"
    property color notifActionText: "#8C2020"
    property color notifUrgentBorder: "#af2f28"

    // ═══════════════════════════════════════════════════════════
    // Status Colors
    // ═══════════════════════════════════════════════════════════
    property color errorColor: "#af2f28"
    property color fgError: "#ffffff"
    property color errorContainer: "#FADED8"
    property color fgErrorContainer: "#891c18"
    property color successColor: "#4F6354"
    property color fgSuccess: "#FFFFFF"
    property color successContainer: "#D1E8D5"
    property color fgSuccessContainer: "#0C1F13"

    // ═══════════════════════════════════════════════════════════
    // Overlay / Scrim
    // ═══════════════════════════════════════════════════════════
    property color scrim: "#000000"
    property color shadow: "#000000"

    // ═══════════════════════════════════════════════════════════
    // Region Override Resolution
    // ═══════════════════════════════════════════════════════════
    property var _roMap: ({})
    property int _roVersion: 0

    function _ro(path: string, fallback: color): color {
        let v = _roVersion;
        return (path in _roMap) ? _roMap[path] : fallback;
    }

    function _resolveRegionValue(path: string): color {
        const parts = path.split(".");
        let obj = region;
        for (const part of parts) {
            if (obj === null || obj === undefined) return "#FF00FF";
            obj = obj[part];
        }
        return obj ?? "#FF00FF";
    }

    // ═══════════════════════════════════════════════════════════
    // Region Tokens (phase-1 foundation)
    // ═══════════════════════════════════════════════════════════
    readonly property RegionTokens region: RegionTokens {}

    component RegionTokens: QtObject {
        readonly property BarRegion bar: BarRegion {}
        readonly property UtilitiesRegion utilities: UtilitiesRegion {}
        readonly property LauncherRegion launcher: LauncherRegion {}
        readonly property PanelRegion panel: PanelRegion {}
        readonly property SharedRegion shared: SharedRegion {}
        readonly property NotificationRegion notification: NotificationRegion {}
        readonly property DashboardRegion dashboard: DashboardRegion {}
        readonly property LockRegion lock: LockRegion {}
        readonly property SidebarRegion sidebar: SidebarRegion {}
        readonly property BackgroundRegion background: BackgroundRegion {}
        readonly property StatePalette state: StatePalette {}
    }

    component StatePalette: QtObject {
        readonly property color error: root._ro("state.error", root.errorColor)
        readonly property color onError: root._ro("state.onError", root.fgError)
        readonly property color errorContainer: root._ro("state.errorContainer", root.errorContainer)
        readonly property color onErrorContainer: root._ro("state.onErrorContainer", root.fgErrorContainer)
        readonly property color success: root._ro("state.success", root.successColor)
        readonly property color onSuccess: root._ro("state.onSuccess", root.fgSuccess)
        readonly property color successContainer: root._ro("state.successContainer", root.successContainer)
        readonly property color onSuccessContainer: root._ro("state.onSuccessContainer", root.fgSuccessContainer)
        readonly property color warning: root._ro("state.warning", root.accentSecondary)
        readonly property color onWarning: root._ro("state.onWarning", root.fgAccentSecondary)
        readonly property color warningContainer: root._ro("state.warningContainer", root.buttonTonalBg)
        readonly property color onWarningContainer: root._ro("state.onWarningContainer", root.buttonTonalText)
        readonly property color scrim: root._ro("state.scrim", root.scrim)
        readonly property color shadow: root._ro("state.shadow", root.shadow)

        readonly property QtObject semantic: QtObject {
            readonly property QtObject feedback: QtObject {
                readonly property color error: root._ro("state.semantic.feedback.error", root.errorColor)
                readonly property color onError: root._ro("state.semantic.feedback.onError", root.fgError)
                readonly property color errorContainer: root._ro("state.semantic.feedback.errorContainer", root.errorContainer)
                readonly property color onErrorContainer: root._ro("state.semantic.feedback.onErrorContainer", root.fgErrorContainer)
                readonly property color success: root._ro("state.semantic.feedback.success", root.successColor)
                readonly property color onSuccess: root._ro("state.semantic.feedback.onSuccess", root.fgSuccess)
                readonly property color successContainer: root._ro("state.semantic.feedback.successContainer", root.successContainer)
                readonly property color onSuccessContainer: root._ro("state.semantic.feedback.onSuccessContainer", root.fgSuccessContainer)
            }

            readonly property QtObject overlay: QtObject {
                readonly property color scrim: root._ro("state.semantic.overlay.scrim", root.scrim)
                readonly property color shadow: root._ro("state.semantic.overlay.shadow", root.shadow)
            }
        }
    }

    component BarRegion: QtObject {
        readonly property color background: root._ro("bar.background", root.barBackground)
        readonly property color text: root._ro("bar.text", root.barText)
        readonly property color icon: root._ro("bar.icon", root.barIcon)
        readonly property color disabledText: root._ro("bar.disabledText", root.textDisabled)

        readonly property color accent: root._ro("bar.accent", root.accentPrimary)
        readonly property color onAccent: root._ro("bar.onAccent", root.fgAccentPrimary)
        readonly property color accentContainer: root._ro("bar.accentContainer", root.accentContainer)
        readonly property color onAccentContainer: root._ro("bar.onAccentContainer", root.fgAccentContainer)
        readonly property color accentTertiary: root._ro("bar.accentTertiary", root.accentTertiary)
        readonly property color onAccentTertiary: root._ro("bar.onAccentTertiary", root.fgAccentTertiary)

        readonly property QtObject chrome: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color background: root._ro("bar.chrome.surface.background", root.barBackground)
            }

            readonly property QtObject foreground: QtObject {
                readonly property color text: root._ro("bar.chrome.foreground.text", root.barText)
                readonly property color icon: root._ro("bar.chrome.foreground.icon", root.barIcon)
                readonly property color disabled: root._ro("bar.chrome.foreground.disabled", root.textDisabled)
            }

            readonly property QtObject accent: QtObject {
                readonly property color primary: root._ro("bar.chrome.accent.primary", root.accentPrimary)
                readonly property color onPrimary: root._ro("bar.chrome.accent.onPrimary", root.fgAccentPrimary)
                readonly property color tertiary: root._ro("bar.chrome.accent.tertiary", root.accentTertiary)
                readonly property color onTertiary: root._ro("bar.chrome.accent.onTertiary", root.fgAccentTertiary)
            }
        }

        readonly property QtObject workspace: QtObject {
            readonly property QtObject container: QtObject {
                readonly property color surface: root._ro("bar.workspace.container.surface", root.surfaceContainer)
                readonly property color surfaceHigh: root._ro("bar.workspace.container.surfaceHigh", root.surfaceContainerHigh)
            }

            readonly property QtObject active: QtObject {
                readonly property color indicator: root._ro("bar.workspace.active.indicator", root.barActiveIndicator)
                readonly property color text: root._ro("bar.workspace.active.text", root.barActiveText)
            }
        }

        readonly property QtObject popout: QtObject {
            readonly property QtObject container: QtObject {
                readonly property color surface: root._ro("bar.popout.container.surface", root.surfaceContainer)
            }

            readonly property QtObject foreground: QtObject {
                readonly property color text: root._ro("bar.popout.foreground.text", root.textPrimary)
                readonly property color subtext: root._ro("bar.popout.foreground.subtext", root.textSecondary)
            }

            readonly property QtObject button: QtObject {
                readonly property color bg: root._ro("bar.popout.button.bg", root.buttonTonalBg)
                readonly property color text: root._ro("bar.popout.button.text", root.buttonTonalText)
            }

            readonly property QtObject network: QtObject {
                readonly property QtObject section: QtObject {
                    readonly property color title: root._ro("bar.popout.network.section.title", root.textPrimary)
                    readonly property color subtitle: root._ro("bar.popout.network.section.subtitle", root.textSecondary)
                }

                readonly property QtObject item: QtObject {
                    readonly property QtObject icon: QtObject {
                        readonly property color active: root._ro("bar.popout.network.item.icon.active", root.accentPrimary)
                        readonly property color inactive: root._ro("bar.popout.network.item.icon.inactive", root.textSecondary)
                    }
                    readonly property QtObject label: QtObject {
                        readonly property color active: root._ro("bar.popout.network.item.label.active", root.accentPrimary)
                        readonly property color inactive: root._ro("bar.popout.network.item.label.inactive", root.textPrimary)
                    }
                    readonly property QtObject action: QtObject {
                        readonly property color bgActive: root._ro("bar.popout.network.item.action.bgActive", root.accentPrimary)
                        readonly property color fgActive: root._ro("bar.popout.network.item.action.fgActive", root.fgAccentPrimary)
                        readonly property color fgInactive: root._ro("bar.popout.network.item.action.fgInactive", root.textPrimary)
                    }
                }

                readonly property QtObject rescan: QtObject {
                    readonly property color bg: root._ro("bar.popout.network.rescan.bg", root.accentPrimary)
                    readonly property color fg: root._ro("bar.popout.network.rescan.fg", root.fgAccentPrimary)
                }
            }

            readonly property QtObject bluetooth: QtObject {
                readonly property QtObject section: QtObject {
                    readonly property color subtitle: root._ro("bar.popout.bluetooth.section.subtitle", root.textSecondary)
                }

                readonly property QtObject device: QtObject {
                    readonly property QtObject action: QtObject {
                        readonly property color bgActive: root._ro("bar.popout.bluetooth.device.action.bgActive", root.accentPrimary)
                        readonly property color fgActive: root._ro("bar.popout.bluetooth.device.action.fgActive", root.fgAccentPrimary)
                        readonly property color fgInactive: root._ro("bar.popout.bluetooth.device.action.fgInactive", root.textPrimary)
                    }
                }

                readonly property QtObject openSettings: QtObject {
                    readonly property color bg: root._ro("bar.popout.bluetooth.openSettings.bg", root.accentPrimary)
                    readonly property color fg: root._ro("bar.popout.bluetooth.openSettings.fg", root.fgAccentPrimary)
                }
            }

            readonly property QtObject tray: QtObject {
                readonly property QtObject item: QtObject {
                    readonly property color divider: root._ro("bar.popout.tray.item.divider", root.panelDivider)
                    readonly property color textEnabled: root._ro("bar.popout.tray.item.textEnabled", root.textPrimary)
                    readonly property color textDisabled: root._ro("bar.popout.tray.item.textDisabled", root.textDisabled)
                }

                readonly property QtObject back: QtObject {
                    readonly property QtObject button: QtObject {
                        readonly property color bg: root._ro("bar.popout.tray.back.button.bg", root.buttonTonalBg)
                        readonly property color text: root._ro("bar.popout.tray.back.button.text", root.buttonTonalText)
                    }
                }
            }

            readonly property QtObject power: QtObject {
                readonly property QtObject profile: QtObject {
                    readonly property color surface: root._ro("bar.popout.power.profile.surface", root.surfaceContainer)
                    readonly property color indicator: root._ro("bar.popout.power.profile.indicator", root.accentPrimary)
                    readonly property color onIndicator: root._ro("bar.popout.power.profile.onIndicator", root.fgAccentPrimary)
                    readonly property color text: root._ro("bar.popout.power.profile.text", root.textPrimary)
                }
            }
        }

        readonly property QtObject media: QtObject {
            readonly property color primary: root._ro("bar.media.primary", root.mediaLinesPrimary)
            readonly property color secondary: root._ro("bar.media.secondary", root.mediaLinesSecondary)
            readonly property color tertiary: root._ro("bar.media.tertiary", root.mediaLinesTertiary)
        }
    }

    component LauncherRegion: QtObject {
        readonly property color background: root._ro("launcher.background", root.launcherBackground)

        readonly property QtObject canvas: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color background: root._ro("launcher.canvas.surface.background", root.launcherBackground)
            }
        }

        readonly property QtObject search: QtObject {
            readonly property QtObject field: QtObject {
                readonly property color bg: root._ro("launcher.search.field.bg", root.launcherSearchBg)
                readonly property color icon: root._ro("launcher.search.field.icon", root.launcherItemSubtext)
                readonly property color clear: root._ro("launcher.search.field.clear", root.launcherItemSubtext)
            }
        }

        readonly property QtObject app: QtObject {
            readonly property QtObject item: QtObject {
                readonly property color highlight: root._ro("launcher.app.item.highlight", root.launcherItemText)
                readonly property color description: root._ro("launcher.app.item.description", root.launcherItemSubtext)
            }
        }

        readonly property QtObject emptyState: QtObject {
            readonly property QtObject content: QtObject {
                readonly property color icon: root._ro("launcher.emptyState.content.icon", root.launcherItemSubtext)
                readonly property color title: root._ro("launcher.emptyState.content.title", root.launcherItemSubtext)
                readonly property color subtitle: root._ro("launcher.emptyState.content.subtitle", root.launcherItemSubtext)
            }
        }

        readonly property QtObject calc: QtObject {
            readonly property QtObject field: QtObject {
                readonly property color placeholder: root._ro("launcher.calc.field.placeholder", root.launcherItemSubtext)
                readonly property color result: root._ro("launcher.calc.field.result", root.launcherItemText)
            }

            readonly property QtObject button: QtObject {
                readonly property color bg: root._ro("launcher.calc.button.bg", root.accentPrimary)
                readonly property color text: root._ro("launcher.calc.button.text", root.fgAccentPrimary)
            }
        }

        readonly property QtObject wallpaper: QtObject {
            readonly property QtObject item: QtObject {
                readonly property color placeholder: root._ro("launcher.wallpaper.item.placeholder", root.launcherSearchBg)
                readonly property color icon: root._ro("launcher.wallpaper.item.icon", root.launcherItemSubtext)
            }
        }
    }

    component PanelRegion: QtObject {
        readonly property QtObject controlCenter: QtObject {
            readonly property QtObject appearance: QtObject {
                readonly property QtObject colorPicker: QtObject {
                    readonly property color accent: root._ro("panel.controlCenter.appearance.colorPicker.accent", root.accentPrimary)
                    readonly property color surface: root._ro("panel.controlCenter.appearance.colorPicker.surface", root.surfaceContainer)
                    readonly property color surfaceHigh: root._ro("panel.controlCenter.appearance.colorPicker.surfaceHigh", root.surfaceContainerHigh)
                    readonly property color border: root._ro("panel.controlCenter.appearance.colorPicker.border", root.panelBorder)
                    readonly property color text: root._ro("panel.controlCenter.appearance.colorPicker.text", root.textPrimary)
                    readonly property color subtext: root._ro("panel.controlCenter.appearance.colorPicker.subtext", root.textSecondary)
                }
            }

            readonly property QtObject bluetooth: QtObject {
                readonly property color accent: root._ro("panel.controlCenter.bluetooth.accent", root.accentPrimary)
                readonly property color onAccent: root._ro("panel.controlCenter.bluetooth.onAccent", root.textOnAccent)
                readonly property color surface: root._ro("panel.controlCenter.bluetooth.surface", root.surfaceContainer)
                readonly property color surfaceHigh: root._ro("panel.controlCenter.bluetooth.surfaceHigh", root.surfaceContainerHigh)
                readonly property color text: root._ro("panel.controlCenter.bluetooth.text", root.textPrimary)
                readonly property color subtext: root._ro("panel.controlCenter.bluetooth.subtext", root.textSecondary)
                readonly property color border: root._ro("panel.controlCenter.bluetooth.border", root.panelBorder)

                readonly property QtObject button: QtObject {
                    readonly property color tonalBg: root._ro("panel.controlCenter.bluetooth.button.tonalBg", root.buttonTonalBg)
                    readonly property color tonalText: root._ro("panel.controlCenter.bluetooth.button.tonalText", root.buttonTonalText)
                }
            }

            readonly property QtObject audio: QtObject {
                readonly property color accent: root._ro("panel.controlCenter.audio.accent", root.accentPrimary)
                readonly property color onAccent: root._ro("panel.controlCenter.audio.onAccent", root.textOnAccent)
                readonly property color surface: root._ro("panel.controlCenter.audio.surface", root.surfaceContainer)
                readonly property color surfaceHigh: root._ro("panel.controlCenter.audio.surfaceHigh", root.surfaceContainerHigh)
                readonly property color text: root._ro("panel.controlCenter.audio.text", root.textPrimary)
                readonly property color subtext: root._ro("panel.controlCenter.audio.subtext", root.textSecondary)
                readonly property color border: root._ro("panel.controlCenter.audio.border", root.panelBorder)

                readonly property QtObject button: QtObject {
                    readonly property color tonalBg: root._ro("panel.controlCenter.audio.button.tonalBg", root.buttonTonalBg)
                    readonly property color tonalText: root._ro("panel.controlCenter.audio.button.tonalText", root.buttonTonalText)
                }
            }

            readonly property QtObject wallpaper: QtObject {
                readonly property color accent: root._ro("panel.controlCenter.wallpaper.accent", root.accentPrimary)
                readonly property color surface: root._ro("panel.controlCenter.wallpaper.surface", root.surfaceContainer)
                readonly property color surfaceBase: root._ro("panel.controlCenter.wallpaper.surfaceBase", root.surfaceBase)
                readonly property color text: root._ro("panel.controlCenter.wallpaper.text", root.textPrimary)
            }

            readonly property QtObject display: QtObject {
                readonly property color surface: root._ro("panel.controlCenter.display.surface", root.surfaceContainer)
                readonly property color surfaceHigh: root._ro("panel.controlCenter.display.surfaceHigh", root.surfaceContainerHigh)
                readonly property color text: root._ro("panel.controlCenter.display.text", root.textPrimary)
                readonly property color subtext: root._ro("panel.controlCenter.display.subtext", root.textSecondary)
                readonly property color border: root._ro("panel.controlCenter.display.border", root.panelBorder)
            }

            readonly property QtObject taskbar: QtObject {
                readonly property color surface: root._ro("panel.controlCenter.taskbar.surface", root.surfaceContainer)
                readonly property color surfaceHigh: root._ro("panel.controlCenter.taskbar.surfaceHigh", root.surfaceContainerHigh)
                readonly property color surfaceHighest: root._ro("panel.controlCenter.taskbar.surfaceHighest", root.surfaceContainerHighest)
                readonly property color text: root._ro("panel.controlCenter.taskbar.text", root.textPrimary)
                readonly property color subtext: root._ro("panel.controlCenter.taskbar.subtext", root.textSecondary)
                readonly property color border: root._ro("panel.controlCenter.taskbar.border", root.panelBorder)

                readonly property QtObject button: QtObject {
                    readonly property color tonalBg: root._ro("panel.controlCenter.taskbar.button.tonalBg", root.buttonTonalBg)
                    readonly property color tonalText: root._ro("panel.controlCenter.taskbar.button.tonalText", root.buttonTonalText)
                }
            }

            readonly property QtObject launcher: QtObject {
                readonly property color surface: root._ro("panel.controlCenter.launcher.surface", root.surfaceContainer)
                readonly property color surfaceHigh: root._ro("panel.controlCenter.launcher.surfaceHigh", root.surfaceContainerHigh)
                readonly property color text: root._ro("panel.controlCenter.launcher.text", root.textPrimary)
                readonly property color subtext: root._ro("panel.controlCenter.launcher.subtext", root.textSecondary)
                readonly property color border: root._ro("panel.controlCenter.launcher.border", root.panelBorder)
            }

            readonly property QtObject network: QtObject {
                readonly property QtObject vpn: QtObject {
                    readonly property color accent: root._ro("panel.controlCenter.network.vpn.accent", root.accentPrimary)
                    readonly property color onAccent: root._ro("panel.controlCenter.network.vpn.onAccent", root.textOnAccent)
                    readonly property color surface: root._ro("panel.controlCenter.network.vpn.surface", root.surfaceContainer)
                    readonly property color surfaceHigh: root._ro("panel.controlCenter.network.vpn.surfaceHigh", root.surfaceContainerHigh)
                    readonly property color surfaceBase: root._ro("panel.controlCenter.network.vpn.surfaceBase", root.surfaceBase)
                    readonly property color text: root._ro("panel.controlCenter.network.vpn.text", root.textPrimary)
                    readonly property color subtext: root._ro("panel.controlCenter.network.vpn.subtext", root.textSecondary)
                    readonly property color border: root._ro("panel.controlCenter.network.vpn.border", root.panelBorder)

                    readonly property QtObject button: QtObject {
                        readonly property color tonalBg: root._ro("panel.controlCenter.network.vpn.button.tonalBg", root.buttonTonalBg)
                        readonly property color tonalText: root._ro("panel.controlCenter.network.vpn.button.tonalText", root.buttonTonalText)
                    }

                    readonly property QtObject actions: QtObject {
                        readonly property color addProviderBg: root._ro("panel.controlCenter.network.vpn.actions.addProviderBg", root.accentPrimary)
                        readonly property color addProviderFg: root._ro("panel.controlCenter.network.vpn.actions.addProviderFg", root.textOnAccent)
                        readonly property color formSecondaryBg: root._ro("panel.controlCenter.network.vpn.actions.formSecondaryBg", root.surfaceContainerHigh)
                        readonly property color formSecondaryFg: root._ro("panel.controlCenter.network.vpn.actions.formSecondaryFg", root.textPrimary)
                        readonly property color formPrimaryBg: root._ro("panel.controlCenter.network.vpn.actions.formPrimaryBg", root.accentPrimary)
                        readonly property color formPrimaryFg: root._ro("panel.controlCenter.network.vpn.actions.formPrimaryFg", root.textOnAccent)
                    }

                    readonly property QtObject item: QtObject {
                        readonly property color selectedBg: root._ro("panel.controlCenter.network.vpn.item.selectedBg", root.surfaceContainer)
                        readonly property color iconContainerIdle: root._ro("panel.controlCenter.network.vpn.item.iconContainerIdle", root.surfaceContainerHigh)
                        readonly property color iconContainerActive: root._ro("panel.controlCenter.network.vpn.item.iconContainerActive", root.accentPrimary)
                        readonly property color iconActive: root._ro("panel.controlCenter.network.vpn.item.iconActive", root.textOnAccent)
                        readonly property color iconIdle: root._ro("panel.controlCenter.network.vpn.item.iconIdle", root.textPrimary)
                        readonly property color statusActive: root._ro("panel.controlCenter.network.vpn.item.statusActive", root.accentPrimary)
                        readonly property color statusIdle: root._ro("panel.controlCenter.network.vpn.item.statusIdle", root.textPrimary)
                        readonly property color statusDisabled: root._ro("panel.controlCenter.network.vpn.item.statusDisabled", root.panelBorder)
                        readonly property color connectPill: root._ro("panel.controlCenter.network.vpn.item.connectPill", root.accentPrimary)
                        readonly property color connectIconActive: root._ro("panel.controlCenter.network.vpn.item.connectIconActive", root.textOnAccent)
                        readonly property color connectIconIdle: root._ro("panel.controlCenter.network.vpn.item.connectIconIdle", root.textPrimary)
                        readonly property color deleteIcon: root._ro("panel.controlCenter.network.vpn.item.deleteIcon", root.textPrimary)
                    }

                    readonly property QtObject dialog: QtObject {
                        readonly property color surface: root._ro("panel.controlCenter.network.vpn.dialog.surface", root.surfaceContainerHigh)
                        readonly property color divider: root._ro("panel.controlCenter.network.vpn.dialog.divider", root.panelBorder)
                        readonly property color fieldLabel: root._ro("panel.controlCenter.network.vpn.dialog.fieldLabel", root.textSecondary)
                        readonly property color fieldBg: root._ro("panel.controlCenter.network.vpn.dialog.fieldBg", root.surfaceContainer)
                        readonly property color fieldBorderActive: root._ro("panel.controlCenter.network.vpn.dialog.fieldBorderActive", root.accentPrimary)
                        readonly property color fieldBorderIdle: root._ro("panel.controlCenter.network.vpn.dialog.fieldBorderIdle", root.panelBorder)
                    }
                }

                readonly property QtObject wireless: QtObject {
                    readonly property color accent: root._ro("panel.controlCenter.network.wireless.accent", root.accentPrimary)
                    readonly property color onAccent: root._ro("panel.controlCenter.network.wireless.onAccent", root.textOnAccent)
                    readonly property color surface: root._ro("panel.controlCenter.network.wireless.surface", root.surfaceContainer)
                    readonly property color surfaceHigh: root._ro("panel.controlCenter.network.wireless.surfaceHigh", root.surfaceContainerHigh)
                    readonly property color surfaceBase: root._ro("panel.controlCenter.network.wireless.surfaceBase", root.surfaceBase)
                    readonly property color text: root._ro("panel.controlCenter.network.wireless.text", root.textPrimary)
                    readonly property color subtext: root._ro("panel.controlCenter.network.wireless.subtext", root.textSecondary)
                    readonly property color border: root._ro("panel.controlCenter.network.wireless.border", root.panelBorder)

                    readonly property QtObject button: QtObject {
                        readonly property color tonalBg: root._ro("panel.controlCenter.network.wireless.button.tonalBg", root.buttonTonalBg)
                        readonly property color tonalText: root._ro("panel.controlCenter.network.wireless.button.tonalText", root.buttonTonalText)
                    }
                }

                readonly property QtObject ethernet: QtObject {
                    readonly property color accent: root._ro("panel.controlCenter.network.ethernet.accent", root.accentPrimary)
                    readonly property color onAccent: root._ro("panel.controlCenter.network.ethernet.onAccent", root.textOnAccent)
                    readonly property color surface: root._ro("panel.controlCenter.network.ethernet.surface", root.surfaceContainer)
                    readonly property color surfaceHigh: root._ro("panel.controlCenter.network.ethernet.surfaceHigh", root.surfaceContainerHigh)
                    readonly property color text: root._ro("panel.controlCenter.network.ethernet.text", root.textPrimary)
                    readonly property color subtext: root._ro("panel.controlCenter.network.ethernet.subtext", root.textSecondary)
                    readonly property color border: root._ro("panel.controlCenter.network.ethernet.border", root.panelBorder)

                    readonly property QtObject button: QtObject {
                        readonly property color tonalBg: root._ro("panel.controlCenter.network.ethernet.button.tonalBg", root.buttonTonalBg)
                        readonly property color tonalText: root._ro("panel.controlCenter.network.ethernet.button.tonalText", root.buttonTonalText)
                    }
                }
            }
        }

        readonly property color surface: root._ro("panel.surface", root.surfaceContainer)
        readonly property color surfaceHigh: root._ro("panel.surfaceHigh", root.surfaceContainerHigh)
        readonly property color surfaceHighest: root._ro("panel.surfaceHighest", root.surfaceContainerHighest)
        readonly property color surfaceBase: root._ro("panel.surfaceBase", root.surfaceBase)
        readonly property color surfaceBright: root._ro("panel.surfaceBright", root.surfaceBright)
        readonly property color text: root._ro("panel.text", root.textPrimary)
        readonly property color subtext: root._ro("panel.subtext", root.textSecondary)
        readonly property color textDisabled: root._ro("panel.textDisabled", root.textDisabled)
        readonly property color border: root._ro("panel.border", root.panelBorder)

        readonly property color accent: root._ro("panel.accent", root.accentPrimary)
        readonly property color onAccent: root._ro("panel.onAccent", root.textOnAccent)
        readonly property color accentSecondary: root._ro("panel.accentSecondary", root.accentSecondary)
        readonly property color onAccentSecondary: root._ro("panel.onAccentSecondary", root.fgAccentSecondary)
        readonly property color accentContainer: root._ro("panel.accentContainer", root.accentContainer)
        readonly property color onAccentContainer: root._ro("panel.onAccentContainer", root.fgAccentContainer)

        readonly property QtObject button: QtObject {
            readonly property color tonalBg: root._ro("panel.button.tonalBg", root.buttonTonalBg)
            readonly property color tonalText: root._ro("panel.button.tonalText", root.buttonTonalText)
            readonly property color filledBg: root._ro("panel.button.filledBg", root.buttonFilledBg)
            readonly property color filledText: root._ro("panel.button.filledText", root.buttonFilledText)
        }

        readonly property QtObject toggle: QtObject {
            readonly property color active: root._ro("panel.toggle.active", root.switchActive)
            readonly property color inactive: root._ro("panel.toggle.inactive", root.switchInactive)
            readonly property color thumb: root._ro("panel.toggle.thumb", root.fgAccentPrimary)
        }

        readonly property QtObject slider: QtObject {
            readonly property color track: root._ro("panel.slider.track", root.sliderTrack)
            readonly property color inactive: root._ro("panel.slider.inactive", root.sliderInactive)
        }
    }

    component SharedRegion: QtObject {
        readonly property QtObject controls: QtObject {
            readonly property color surface: root._ro("shared.controls.surface", root.surfaceContainer)
            readonly property color surfaceHigh: root._ro("shared.controls.surfaceHigh", root.surfaceContainerHigh)
            readonly property color surfaceHighest: root._ro("shared.controls.surfaceHighest", root.surfaceContainerHighest)
            readonly property color surfaceBase: root._ro("shared.controls.surfaceBase", root.surfaceBase)
            readonly property color surfaceBright: root._ro("shared.controls.surfaceBright", root.surfaceBright)
            readonly property color text: root._ro("shared.controls.text", root.textPrimary)
            readonly property color subtext: root._ro("shared.controls.subtext", root.textSecondary)
            readonly property color textDisabled: root._ro("shared.controls.textDisabled", root.textDisabled)
            readonly property color border: root._ro("shared.controls.border", root.panelBorder)

            readonly property color accent: root._ro("shared.controls.accent", root.accentPrimary)
            readonly property color onAccent: root._ro("shared.controls.onAccent", root.textOnAccent)
            readonly property color accentSecondary: root._ro("shared.controls.accentSecondary", root.accentSecondary)
            readonly property color onAccentSecondary: root._ro("shared.controls.onAccentSecondary", root.fgAccentSecondary)
            readonly property color accentContainer: root._ro("shared.controls.accentContainer", root.accentContainer)
            readonly property color onAccentContainer: root._ro("shared.controls.onAccentContainer", root.fgAccentContainer)

            readonly property QtObject common: QtObject {
                readonly property color surface: root._ro("shared.controls.common.surface", controls.surface)
                readonly property color surfaceHigh: root._ro("shared.controls.common.surfaceHigh", controls.surfaceHigh)
                readonly property color surfaceHighest: root._ro("shared.controls.common.surfaceHighest", controls.surfaceHighest)
                readonly property color surfaceBase: root._ro("shared.controls.common.surfaceBase", controls.surfaceBase)
                readonly property color surfaceBright: root._ro("shared.controls.common.surfaceBright", controls.surfaceBright)
                readonly property color text: root._ro("shared.controls.common.text", controls.text)
                readonly property color subtext: root._ro("shared.controls.common.subtext", controls.subtext)
                readonly property color textDisabled: root._ro("shared.controls.common.textDisabled", controls.textDisabled)
                readonly property color border: root._ro("shared.controls.common.border", controls.border)

                readonly property color accent: root._ro("shared.controls.common.accent", controls.accent)
                readonly property color onAccent: root._ro("shared.controls.common.onAccent", controls.onAccent)
                readonly property color accentSecondary: root._ro("shared.controls.common.accentSecondary", controls.accentSecondary)
                readonly property color onAccentSecondary: root._ro("shared.controls.common.onAccentSecondary", controls.onAccentSecondary)
                readonly property color accentContainer: root._ro("shared.controls.common.accentContainer", controls.accentContainer)
                readonly property color onAccentContainer: root._ro("shared.controls.common.onAccentContainer", controls.onAccentContainer)
            }

            readonly property QtObject button: QtObject {
                readonly property color tonalBg: root._ro("shared.controls.button.tonalBg", root.buttonTonalBg)
                readonly property color tonalText: root._ro("shared.controls.button.tonalText", root.buttonTonalText)
                readonly property color filledBg: root._ro("shared.controls.button.filledBg", root.buttonFilledBg)
                readonly property color filledText: root._ro("shared.controls.button.filledText", root.buttonFilledText)
            }

            readonly property QtObject toggle: QtObject {
                readonly property color active: root._ro("shared.controls.toggle.active", root.switchActive)
                readonly property color inactive: root._ro("shared.controls.toggle.inactive", root.switchInactive)
                readonly property color thumb: root._ro("shared.controls.toggle.thumb", root.fgAccentPrimary)
            }

            readonly property QtObject slider: QtObject {
                readonly property color track: root._ro("shared.controls.slider.track", root.sliderTrack)
                readonly property color inactive: root._ro("shared.controls.slider.inactive", root.sliderInactive)
            }
        }
    }

    component NotificationRegion: QtObject {
        readonly property color background: root._ro("notification.background", root.notifBackground)

        readonly property QtObject container: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color background: root._ro("notification.container.surface.background", root.notifBackground)
            }
        }

        readonly property QtObject toast: QtObject {
            readonly property QtObject container: QtObject {
                readonly property color normal: root._ro("notification.toast.container.normal", root.surfaceContainer)
                readonly property color critical: root._ro("notification.toast.container.critical", root.notifActionBg)
            }

            readonly property QtObject badge: QtObject {
                readonly property color critical: root._ro("notification.toast.badge.critical", root.notifUrgentBorder)
                readonly property color normal: root._ro("notification.toast.badge.normal", root.notifActionBg)
                readonly property color low: root._ro("notification.toast.badge.low", root.notifActionBg)
            }

            readonly property QtObject icon: QtObject {
                readonly property color critical: root._ro("notification.toast.icon.critical", root.fgError)
                readonly property color normal: root._ro("notification.toast.icon.normal", root.notifActionText)
                readonly property color low: root._ro("notification.toast.icon.low", root.notifText)
            }

            readonly property QtObject text: QtObject {
                readonly property color appName: root._ro("notification.toast.text.appName", root.notifSubtext)
                readonly property color time: root._ro("notification.toast.text.time", root.notifSubtext)
                readonly property color body: root._ro("notification.toast.text.body", root.notifSubtext)
            }

            readonly property QtObject expand: QtObject {
                readonly property color critical: root._ro("notification.toast.expand.critical", root.notifActionText)
                readonly property color normal: root._ro("notification.toast.expand.normal", root.notifText)
            }

            readonly property QtObject action: QtObject {
                readonly property color normalBg: root._ro("notification.toast.action.normalBg", root.notifActionBg)
                readonly property color criticalBg: root._ro("notification.toast.action.criticalBg", root.notifUrgentBorder)
                readonly property color normalText: root._ro("notification.toast.action.normalText", root.notifSubtext)
                readonly property color criticalText: root._ro("notification.toast.action.criticalText", root.fgAccentSecondary)
                readonly property color normalStateLayer: root._ro("notification.toast.action.normalStateLayer", root.notifText)
                readonly property color criticalStateLayer: root._ro("notification.toast.action.criticalStateLayer", root.fgAccentSecondary)
            }
        }

        readonly property QtObject indicator: QtObject {
            readonly property color bg: root._ro("notification.indicator.bg", root.accentTertiary)
            readonly property color text: root._ro("notification.indicator.text", root.fgAccentTertiary)

            readonly property QtObject badge: QtObject {
                readonly property color bg: root._ro("notification.indicator.badge.bg", indicator.bg)
                readonly property color text: root._ro("notification.indicator.badge.text", indicator.text)
            }
        }
    }

    component DashboardRegion: QtObject {
        readonly property color background: root._ro("dashboard.background", root.panelBackground)

        readonly property QtObject canvas: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color background: root._ro("dashboard.canvas.surface.background", root.panelBackground)
            }
        }

        readonly property QtObject card: QtObject {
            readonly property QtObject container: QtObject {
                readonly property color surface: root._ro("dashboard.card.container.surface", root.surfaceContainer)
            }
        }

        readonly property QtObject tabs: QtObject {
            readonly property QtObject line: QtObject {
                readonly property color indicator: root._ro("dashboard.tabs.line.indicator", root.accentPrimary)
                readonly property color divider: root._ro("dashboard.tabs.line.divider", root.panelDivider)
            }

            readonly property QtObject state: QtObject {
                readonly property color activeIcon: root._ro("dashboard.tabs.state.activeIcon", root.accentPrimary)
                readonly property color activeLabel: root._ro("dashboard.tabs.state.activeLabel", root.accentPrimary)
                readonly property color inactiveIcon: root._ro("dashboard.tabs.state.inactiveIcon", root.textSecondary)
                readonly property color inactiveLabel: root._ro("dashboard.tabs.state.inactiveLabel", root.textSecondary)
            }
        }

        readonly property QtObject calendar: QtObject {
            readonly property QtObject header: QtObject {
                readonly property color nav: root._ro("dashboard.calendar.header.nav", root.accentTertiary)
                readonly property color monthYear: root._ro("dashboard.calendar.header.monthYear", root.accentPrimary)
            }

            readonly property QtObject weekday: QtObject {
                readonly property color workday: root._ro("dashboard.calendar.weekday.workday", root.textSecondary)
                readonly property color weekend: root._ro("dashboard.calendar.weekday.weekend", root.accentSecondary)
            }

            readonly property QtObject day: QtObject {
                readonly property QtObject currentMonth: QtObject {
                    readonly property color workday: root._ro("dashboard.calendar.day.currentMonth.workday", root.textSecondary)
                    readonly property color weekend: root._ro("dashboard.calendar.day.currentMonth.weekend", root.accentSecondary)
                }

                readonly property color otherMonth: root._ro("dashboard.calendar.day.otherMonth", root.textDisabled)

                readonly property QtObject today: QtObject {
                    readonly property color bg: root._ro("dashboard.calendar.day.today.bg", root.accentPrimary)
                    readonly property color fg: root._ro("dashboard.calendar.day.today.fg", root.fgAccentPrimary)
                    readonly property color source: root._ro("dashboard.calendar.day.today.source", root.textPrimary)
                }

            }
        }

        readonly property QtObject dateTime: QtObject {
            readonly property QtObject clock: QtObject {
                readonly property color hours: root._ro("dashboard.dateTime.clock.hours", root.accentSecondary)
                readonly property color minutes: root._ro("dashboard.dateTime.clock.minutes", root.accentSecondary)
                readonly property color separator: root._ro("dashboard.dateTime.clock.separator", root.accentPrimary)
                readonly property color amPm: root._ro("dashboard.dateTime.clock.amPm", root.accentPrimary)
            }

        }

        readonly property QtObject user: QtObject {
            readonly property QtObject avatar: QtObject {
                readonly property QtObject container: QtObject {
                    readonly property color background: root._ro("dashboard.user.avatar.container.background", root.surfaceContainerHigh)
                }
                readonly property QtObject action: QtObject {
                    readonly property color bg: root._ro("dashboard.user.avatar.action.bg", root.accentPrimary)
                    readonly property color icon: root._ro("dashboard.user.avatar.action.icon", root.fgAccentPrimary)
                }

            }
            readonly property QtObject info: QtObject {
                readonly property QtObject icon: QtObject {
                    readonly property color os: root._ro("dashboard.user.info.icon.os", root.accentPrimary)
                    readonly property color wm: root._ro("dashboard.user.info.icon.wm", root.accentSecondary)
                    readonly property color uptime: root._ro("dashboard.user.info.icon.uptime", root.accentTertiary)
                }

            }
        }

        readonly property QtObject weather: QtObject {
            readonly property QtObject header: QtObject {
                readonly property color city: root._ro("dashboard.weather.header.city", root.textPrimary)
                readonly property color date: root._ro("dashboard.weather.header.date", root.textSecondary)
            }
            readonly property QtObject current: QtObject {
                readonly property color card: root._ro("dashboard.weather.current.card", root.surfaceContainer)
                readonly property color icon: root._ro("dashboard.weather.current.icon", root.accentPrimary)
                readonly property color temperature: root._ro("dashboard.weather.current.temperature", root.accentPrimary)
                readonly property color description: root._ro("dashboard.weather.current.description", root.textSecondary)
                readonly property color sunriseSunset: root._ro("dashboard.weather.current.sunriseSunset", root.accentPrimary)
            }
            readonly property QtObject detail: QtObject {
                readonly property color card: root._ro("dashboard.weather.detail.card", root.surfaceContainer)
                readonly property color icon: root._ro("dashboard.weather.detail.icon", root.accentPrimary)
            }
            readonly property QtObject stat: QtObject {
                readonly property color label: root._ro("dashboard.weather.stat.label", root.textSecondary)
                readonly property color value: root._ro("dashboard.weather.stat.value", root.textPrimary)
            }
            readonly property QtObject forecast: QtObject {
                readonly property color heading: root._ro("dashboard.weather.forecast.heading", root.textPrimary)
                readonly property color card: root._ro("dashboard.weather.forecast.card", root.surfaceContainer)
                readonly property color day: root._ro("dashboard.weather.forecast.day", root.textPrimary)
                readonly property color date: root._ro("dashboard.weather.forecast.date", root.textSecondary)
                readonly property color icon: root._ro("dashboard.weather.forecast.icon", root.accentPrimary)
                readonly property color temps: root._ro("dashboard.weather.forecast.temps", root.textPrimary)
            }

        }

        readonly property QtObject dashWeather: QtObject {
            readonly property QtObject current: QtObject {
                readonly property color icon: root._ro("dashboard.dashWeather.current.icon", root.accentSecondary)
                readonly property color temperature: root._ro("dashboard.dashWeather.current.temperature", root.accentPrimary)
            }

        }

        readonly property QtObject media: QtObject {
            readonly property QtObject nowPlaying: QtObject {
                readonly property QtObject cover: QtObject {
                    readonly property color core: root._ro("dashboard.media.nowPlaying.cover.core", root.accentPrimary)
                    readonly property color fade: root._ro("dashboard.media.nowPlaying.cover.fade", root.surfaceBase)
                }
                readonly property QtObject title: QtObject {
                    readonly property color active: root._ro("dashboard.media.nowPlaying.title.active", root.accentPrimary)
                    readonly property color inactive: root._ro("dashboard.media.nowPlaying.title.inactive", root.textPrimary)
                }
                readonly property color album: root._ro("dashboard.media.nowPlaying.album", root.panelBorder)
                readonly property QtObject artist: QtObject {
                    readonly property color active: root._ro("dashboard.media.nowPlaying.artist.active", root.accentSecondary)
                    readonly property color inactive: root._ro("dashboard.media.nowPlaying.artist.inactive", root.panelBorder)
                }
            }

            readonly property QtObject player: QtObject {
                readonly property QtObject controls: QtObject {
                    readonly property QtObject playPause: QtObject {
                        readonly property color fg: root._ro("dashboard.media.player.controls.playPause.fg", root.accentPrimary)
                        readonly property color bg: root._ro("dashboard.media.player.controls.playPause.bg", root.surfaceContainer)
                    }
                    readonly property color skip: root._ro("dashboard.media.player.controls.skip", root.textSecondary)
                    readonly property color raise: root._ro("dashboard.media.player.controls.raise", root.accentSecondary)
                    readonly property color disabled: root._ro("dashboard.media.player.controls.disabled", root.panelBorder)
                }

                readonly property QtObject visualiser: QtObject {
                    readonly property color baseline: root._ro("dashboard.media.player.visualiser.baseline", root.accentTertiary)
                    readonly property color barDim: root._ro("dashboard.media.player.visualiser.barDim", root.accentTertiary)
                    readonly property color barBright: root._ro("dashboard.media.player.visualiser.barBright", root.accentPrimary)
                }
            }

            readonly property QtObject timeline: QtObject {
                readonly property color position: root._ro("dashboard.media.timeline.position", root.textSecondary)
                readonly property color length: root._ro("dashboard.media.timeline.length", root.textSecondary)
            }

            readonly property QtObject visualiser: QtObject {
                readonly property color baseline: root._ro("dashboard.media.visualiser.baseline", root.accentTertiary)
                readonly property color barDim: root._ro("dashboard.media.visualiser.barDim", root.accentTertiary)
                readonly property color barBright: root._ro("dashboard.media.visualiser.barBright", root.accentPrimary)
            }

        }

        readonly property QtObject dashMedia: QtObject {
            readonly property QtObject compact: QtObject {
                readonly property QtObject nowPlaying: QtObject {
                    readonly property QtObject cover: QtObject {
                        readonly property color core: root._ro("dashboard.dashMedia.compact.nowPlaying.cover.core", root.accentPrimary)
                        readonly property color fade: root._ro("dashboard.dashMedia.compact.nowPlaying.cover.fade", root.surfaceBase)
                    }
                    readonly property color title: root._ro("dashboard.dashMedia.compact.nowPlaying.title", root.accentPrimary)
                    readonly property color album: root._ro("dashboard.dashMedia.compact.nowPlaying.album", root.panelBorder)
                    readonly property color artist: root._ro("dashboard.dashMedia.compact.nowPlaying.artist", root.accentSecondary)
                }

                readonly property QtObject player: QtObject {
                    readonly property QtObject controls: QtObject {
                        readonly property color playPause: root._ro("dashboard.dashMedia.compact.player.controls.playPause", root.accentPrimary)
                        readonly property color skip: root._ro("dashboard.dashMedia.compact.player.controls.skip", root.textSecondary)
                        readonly property color disabled: root._ro("dashboard.dashMedia.compact.player.controls.disabled", root.panelBorder)
                    }
                    readonly property QtObject visualiser: QtObject {
                        readonly property color baseline: root._ro("dashboard.dashMedia.compact.player.visualiser.baseline", root.accentTertiary)
                        readonly property color barDim: root._ro("dashboard.dashMedia.compact.player.visualiser.barDim", root.accentTertiary)
                        readonly property color barBright: root._ro("dashboard.dashMedia.compact.player.visualiser.barBright", root.accentPrimary)
                    }
                }

            }
        }

        readonly property QtObject performance: QtObject {
            readonly property QtObject resource: QtObject {
                readonly property QtObject arc: QtObject {
                    readonly property color fg1: root._ro("dashboard.performance.resource.arc.fg1", root.accentPrimary)
                    readonly property color fg2: root._ro("dashboard.performance.resource.arc.fg2", root.accentSecondary)
                    readonly property color bg1: root._ro("dashboard.performance.resource.arc.bg1", root.accentContainer)
                    readonly property color bg2: root._ro("dashboard.performance.resource.arc.bg2", root.buttonTonalBg)
                }
                readonly property color sublabel: root._ro("dashboard.performance.resource.sublabel", root.textSecondary)
            }
        }

        readonly property QtObject dashResources: QtObject {
            readonly property QtObject metric: QtObject {
                readonly property color cpu: root._ro("dashboard.dashResources.metric.cpu", root.accentPrimary)
                readonly property color memory: root._ro("dashboard.dashResources.metric.memory", root.accentSecondary)
                readonly property color storage: root._ro("dashboard.dashResources.metric.storage", root.accentTertiary)
            }
            readonly property QtObject progress: QtObject {
                readonly property color track: root._ro("dashboard.dashResources.progress.track", root.surfaceContainerHigh)
            }

        }
    }

    component LockRegion: QtObject {
        readonly property QtObject layout: QtObject {
            readonly property color background: root._ro("lock.layout.background", root.barBackground)
        }

        readonly property QtObject card: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color base: root._ro("lock.card.surface.base", root.surfaceContainer)
                readonly property color high: root._ro("lock.card.surface.high", root.surfaceContainerHigh)
                readonly property color highest: root._ro("lock.card.surface.highest", root.surfaceContainerHighest)
            }
        }

        readonly property QtObject typography: QtObject {
            readonly property QtObject role: QtObject {
                readonly property color primary: root._ro("lock.typography.role.primary", root.textPrimary)
                readonly property color secondary: root._ro("lock.typography.role.secondary", root.textSecondary)
                readonly property color disabled: root._ro("lock.typography.role.disabled", root.textDisabled)
            }
        }

        readonly property QtObject tones: QtObject {
            readonly property color onPrimary: root._ro("lock.tones.onPrimary", root.textOnAccent)

            readonly property QtObject role: QtObject {
                readonly property color primary: root._ro("lock.tones.role.primary", root.accentPrimary)
                readonly property color secondary: root._ro("lock.tones.role.secondary", root.accentSecondary)
                readonly property color tertiary: root._ro("lock.tones.role.tertiary", root.accentTertiary)
            }
        }

        readonly property QtObject outline: QtObject {
            readonly property QtObject stroke: QtObject {
                readonly property color border: root._ro("lock.outline.stroke.border", root.panelBorder)
                readonly property color divider: root._ro("lock.outline.stroke.divider", root.panelDivider)
            }
        }

        readonly property QtObject notifications: QtObject {
            readonly property QtObject group: QtObject {
                readonly property color bg: root._ro("lock.notifications.group.bg", root.buttonTonalBg)
                readonly property color text: root._ro("lock.notifications.group.text", root.buttonTonalText)

                readonly property QtObject container: QtObject {
                    readonly property color bg: root._ro("lock.notifications.group.container.bg", root.buttonTonalBg)
                    readonly property color lowBg: root._ro("lock.notifications.group.container.lowBg", card.surface.highest)
                }

                readonly property QtObject content: QtObject {
                    readonly property color text: root._ro("lock.notifications.group.content.text", root.buttonTonalText)
                }
            }
        }

        readonly property QtObject visualiser: QtObject {
            readonly property QtObject wave: QtObject {
                readonly property color primary: root._ro("lock.visualiser.wave.primary", root.mediaLinesPrimary)
                readonly property color secondary: root._ro("lock.visualiser.wave.secondary", root.mediaLinesSecondary)
                readonly property color tertiary: root._ro("lock.visualiser.wave.tertiary", root.mediaLinesTertiary)
            }
        }
    }

    component SidebarRegion: QtObject {
        readonly property color background: root._ro("sidebar.background", root.panelBackground)

        readonly property QtObject layout: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color background: root._ro("sidebar.layout.surface.background", root.panelBackground)
            }

            readonly property QtObject container: QtObject {
                readonly property color surface: root._ro("sidebar.layout.container.surface", root.surfaceContainerLow)
                readonly property color divider: root._ro("sidebar.layout.container.divider", root.panelDivider)
            }

            readonly property QtObject dock: QtObject {
                readonly property QtObject meta: QtObject {
                    readonly property color count: root._ro("sidebar.layout.dock.meta.count", root.panelBorder)
                    readonly property color title: root._ro("sidebar.layout.dock.meta.title", root.panelBorder)
                    readonly property color emptyIcon: root._ro("sidebar.layout.dock.meta.emptyIcon", root.panelDivider)
                    readonly property color emptyText: root._ro("sidebar.layout.dock.meta.emptyText", root.panelDivider)
                }
            }
        }

        readonly property QtObject notifications: QtObject {
            readonly property QtObject group: QtObject {
                readonly property color surface: root._ro("sidebar.notifications.group.surface", root.surfaceContainer)
                readonly property color appName: root._ro("sidebar.notifications.group.appName", root.textSecondary)
                readonly property color time: root._ro("sidebar.notifications.group.time", root.panelBorder)

                readonly property QtObject icon: QtObject {
                    readonly property color critical: root._ro("sidebar.notifications.group.icon.critical", root.fgError)
                    readonly property color normal: root._ro("sidebar.notifications.group.icon.normal", root.buttonTonalText)
                    readonly property color low: root._ro("sidebar.notifications.group.icon.low", root.textPrimary)
                }

                readonly property QtObject badge: QtObject {
                    readonly property color criticalBg: root._ro("sidebar.notifications.group.badge.criticalBg", root.errorColor)
                    readonly property color normalBg: root._ro("sidebar.notifications.group.badge.normalBg", root.buttonTonalBg)
                    readonly property color lowBg: root._ro("sidebar.notifications.group.badge.lowBg", root.surfaceContainerHigh)
                }

                readonly property QtObject counter: QtObject {
                    readonly property color criticalBg: root._ro("sidebar.notifications.group.counter.criticalBg", root.errorColor)
                    readonly property color normalBg: root._ro("sidebar.notifications.group.counter.normalBg", root.surfaceContainerHigh)
                    readonly property color criticalText: root._ro("sidebar.notifications.group.counter.criticalText", root.fgError)
                    readonly property color normalText: root._ro("sidebar.notifications.group.counter.normalText", root.textPrimary)
                }
            }

            readonly property QtObject item: QtObject {
                readonly property color criticalBg: root._ro("sidebar.notifications.item.criticalBg", root.buttonTonalBg)
                readonly property color normalBg: root._ro("sidebar.notifications.item.normalBg", root.surfaceContainerHigh)
                readonly property color criticalText: root._ro("sidebar.notifications.item.criticalText", root.buttonTonalText)
                readonly property color normalText: root._ro("sidebar.notifications.item.normalText", root.textPrimary)
                readonly property color criticalBody: root._ro("sidebar.notifications.item.criticalBody", root.accentPrimary)
                readonly property color normalBody: root._ro("sidebar.notifications.item.normalBody", root.panelBorder)
                readonly property color time: root._ro("sidebar.notifications.item.time", root.panelBorder)
            }
        }

        readonly property QtObject action: QtObject {
            readonly property QtObject control: QtObject {
                readonly property color surface: root._ro("sidebar.action.control.surface", root.surfaceContainerHighest)
                readonly property color text: root._ro("sidebar.action.control.text", root.textSecondary)
            }
        }
    }

    component BackgroundRegion: QtObject {
        readonly property QtObject scene: QtObject {
            readonly property QtObject visualiser: QtObject {
                readonly property color bars: root._ro("background.scene.visualiser.bars", root.accentPrimary)
                readonly property color glow: root._ro("background.scene.visualiser.glow", root.inversePrimary)
            }
            readonly property QtObject wallpaper: QtObject {
                readonly property color placeholder: root._ro("background.scene.wallpaper.placeholder", root.surfaceContainer)
                readonly property color icon: root._ro("background.scene.wallpaper.icon", root.textSecondary)
                readonly property color retryBg: root._ro("background.scene.wallpaper.retryBg", root.accentPrimary)
                readonly property color retryIcon: root._ro("background.scene.wallpaper.retryIcon", root.fgAccentPrimary)
            }
            readonly property QtObject clock: QtObject {
                readonly property color hours: root._ro("background.scene.clock.hours", root.accentPrimary)
                readonly property color minutes: root._ro("background.scene.clock.minutes", root.accentSecondary)
                readonly property color separator: root._ro("background.scene.clock.separator", root.accentTertiary)
                readonly property color dateBg: root._ro("background.scene.clock.dateBg", root.surfaceBase)
            }
        }

    }

    component UtilitiesRegion: QtObject {
        readonly property color background: root._ro("utilities.background", root.surfaceBase)

        readonly property QtObject canvas: QtObject {
            readonly property QtObject surface: QtObject {
                readonly property color background: root._ro("utilities.canvas.surface.background", root.surfaceBase)
            }
        }

        readonly property QtObject cards: QtObject {
            readonly property QtObject idleInhibit: QtObject {
                readonly property QtObject container: QtObject {
                    readonly property color surface: root._ro("utilities.cards.idleInhibit.container.surface", root.surfaceContainer)
                }
                readonly property QtObject status: QtObject {
                    readonly property color activeBg: root._ro("utilities.cards.idleInhibit.status.activeBg", root.accentPrimary)
                    readonly property color activeIcon: root._ro("utilities.cards.idleInhibit.status.activeIcon", root.textOnAccent)
                    readonly property color inactiveBg: root._ro("utilities.cards.idleInhibit.status.inactiveBg", root.buttonTonalBg)
                    readonly property color inactiveIcon: root._ro("utilities.cards.idleInhibit.status.inactiveIcon", root.buttonTonalText)
                }
                readonly property color subtitle: root._ro("utilities.cards.idleInhibit.subtitle", root.textSecondary)
                readonly property QtObject chip: QtObject {
                    readonly property color bg: root._ro("utilities.cards.idleInhibit.chip.bg", root.accentPrimary)
                    readonly property color fg: root._ro("utilities.cards.idleInhibit.chip.fg", root.textOnAccent)
                }
            }

            readonly property QtObject record: QtObject {
                readonly property QtObject container: QtObject {
                    readonly property color surface: root._ro("utilities.cards.record.container.surface", root.surfaceContainer)
                }
                readonly property QtObject status: QtObject {
                    readonly property color activeBg: root._ro("utilities.cards.record.status.activeBg", root.accentPrimary)
                    readonly property color activeIcon: root._ro("utilities.cards.record.status.activeIcon", root.textOnAccent)
                    readonly property color mutedBg: root._ro("utilities.cards.record.status.mutedBg", root.buttonTonalBg)
                    readonly property color mutedIcon: root._ro("utilities.cards.record.status.mutedIcon", root.buttonTonalText)
                }
                readonly property color subtitle: root._ro("utilities.cards.record.subtitle", root.textSecondary)
                readonly property QtObject destructive: QtObject {
                    readonly property color bg: root._ro("utilities.cards.record.destructive.bg", root.errorColor)
                    readonly property color fg: root._ro("utilities.cards.record.destructive.fg", root.fgError)
                }
            }

            readonly property QtObject recordings: QtObject {
                readonly property QtObject list: QtObject {
                    readonly property color text: root._ro("utilities.cards.recordings.list.text", root.textSecondary)
                }
                readonly property QtObject empty: QtObject {
                    readonly property color border: root._ro("utilities.cards.recordings.empty.border", root.panelBorder)
                }
                readonly property QtObject action: QtObject {
                    readonly property color deleteColor: root._ro("utilities.cards.recordings.action.deleteColor", root.errorColor)
                }
            }
        }

        readonly property QtObject card: QtObject {
            readonly property color surface: root._ro("utilities.card.surface", root.surfaceContainer)
            readonly property color surfaceHigh: root._ro("utilities.card.surfaceHigh", root.surfaceContainerHigh)
            readonly property color surfaceHighest: root._ro("utilities.card.surfaceHighest", root.surfaceContainerHighest)
            readonly property color border: root._ro("utilities.card.border", root.panelBorder)
            readonly property color label: root._ro("utilities.card.label", root.textSecondary)
            readonly property color icon: root._ro("utilities.card.icon", root.barIcon)
            readonly property color text: root._ro("utilities.card.text", root.textSecondary)

            readonly property QtObject status: QtObject {
                readonly property color activeBg: root._ro("utilities.card.status.activeBg", root.accentPrimary)
                readonly property color activeIcon: root._ro("utilities.card.status.activeIcon", root.textOnAccent)
                readonly property color mutedBg: root._ro("utilities.card.status.mutedBg", root.buttonTonalBg)
                readonly property color mutedIcon: root._ro("utilities.card.status.mutedIcon", root.buttonTonalText)
            }

            readonly property QtObject container: QtObject {
                readonly property color surface: root._ro("utilities.card.container.surface", root.surfaceContainer)
            }
        }

        readonly property QtObject toggle: QtObject {
            readonly property color activeBg: root._ro("utilities.toggle.activeBg", root.accentPrimary)
            readonly property color activeIcon: root._ro("utilities.toggle.activeIcon", root.textOnAccent)
            readonly property color inactiveBg: root._ro("utilities.toggle.inactiveBg", root.buttonTonalBg)
            readonly property color inactiveIcon: root._ro("utilities.toggle.inactiveIcon", root.buttonTonalText)
            readonly property color label: root._ro("utilities.toggle.label", root.textSecondary)
            readonly property color labelInactive: root._ro("utilities.toggle.labelInactive", root.textSecondary)
            readonly property color pillInactive: root._ro("utilities.toggle.pillInactive", root.surfaceContainerHighest)
            readonly property color surface: root._ro("utilities.toggle.surface", root.surfaceContainerHighest)

            readonly property QtObject state: QtObject {
                readonly property color labelInactive: root._ro("utilities.toggle.state.labelInactive", root.textSecondary)
                readonly property color pillInactive: root._ro("utilities.toggle.state.pillInactive", root.surfaceContainerHighest)
            }
        }

        readonly property QtObject slider: QtObject {
            readonly property color icon: root._ro("utilities.slider.icon", root.textSecondary)

            readonly property QtObject thumb: QtObject {
                readonly property color icon: root._ro("utilities.slider.thumb.icon", root.textSecondary)
            }
        }

        readonly property QtObject action: QtObject {
            readonly property color accent: root._ro("utilities.action.accent", root.accentPrimary)
            readonly property color onAccent: root._ro("utilities.action.onAccent", root.textOnAccent)
        }

        readonly property QtObject toast: QtObject {
            readonly property QtObject item: QtObject {
                readonly property color defaultBg: root._ro("utilities.toast.item.defaultBg", root.surfaceBase)
                readonly property color warningBg: root._ro("utilities.toast.item.warningBg", root.accentSecondary)
                readonly property color defaultBorder: root._ro("utilities.toast.item.defaultBorder", root.panelDivider)
                readonly property color warningBorder: root._ro("utilities.toast.item.warningBorder", root.accentSecondary)
                readonly property color defaultIconBg: root._ro("utilities.toast.item.defaultIconBg", root.surfaceContainerHigh)
                readonly property color defaultIconFg: root._ro("utilities.toast.item.defaultIconFg", root.textSecondary)
                readonly property color warningIconBg: root._ro("utilities.toast.item.warningIconBg", root.buttonTonalBg)
                readonly property color warningIconFg: root._ro("utilities.toast.item.warningIconFg", root.buttonTonalText)
                readonly property color defaultTitle: root._ro("utilities.toast.item.defaultTitle", root.textPrimary)
                readonly property color warningTitle: root._ro("utilities.toast.item.warningTitle", root.fgAccentPrimary)
                readonly property color defaultBody: root._ro("utilities.toast.item.defaultBody", root.textSecondary)
                readonly property color warningBody: root._ro("utilities.toast.item.warningBody", root.fgAccentPrimary)
            }

        }

        readonly property QtObject modal: QtObject {
            readonly property QtObject overlay: QtObject {
                readonly property color scrim: root._ro("utilities.modal.overlay.scrim", root.scrim)
            }

            readonly property QtObject content: QtObject {
                readonly property color surface: root._ro("utilities.modal.content.surface", root.surfaceContainerHigh)
                readonly property color text: root._ro("utilities.modal.content.text", root.textSecondary)
            }
        }
    }

    // ═══════════════════════════════════════════════════════════
    // Dark Mode
    // ═══════════════════════════════════════════════════════════
    property bool isDark: false
    property bool themeReady: false

    function applyModeFromConfig(): void {
        const wantedDark = Config.appearance.isDark ?? false;
        const currentDark = !Colours.currentLight;

        isDark = wantedDark;
        if (currentDark !== wantedDark)
            Colours.setMode(wantedDark ? "dark" : "light");

        _bindDefaults();
        _applyOverrides();
    }

    function setDark(dark: bool): void {
        if (isDark === dark) return;
        // 1. Save current mode overrides
        _save();
        // 2. Switch mode
        isDark = dark;
        // 3. Update Colours for legacy consumers
        Colours.setMode(dark ? "dark" : "light");
        // 4. Rebind all defaults (M3 palette will update reactively)
        _bindDefaults();
        // 5. Load overrides for new mode
        _load();
        if (Config.appearance.isDark !== dark) {
            Config.appearance.isDark = dark;
            Config.save();
        }
    }

    // ═══════════════════════════════════════════════════════════
    // Highlight: rainbow cycle + preview lock (ESC to exit)
    // ═══════════════════════════════════════════════════════════
    property string highlightedToken: ""
    property real _hue: 0
    property bool previewLocked: false

    // Saved state for restore
    property bool _wasOverride: false
    property string _savedValue: ""
    property var _savedVisState: ({})

    Timer {
        id: _rainbowTimer
        interval: 30
        repeat: true
        onTriggered: {
            root._hue = (root._hue + 0.01) % 1.0;
            const key = root.highlightedToken;
            if (key === "") return;
            const c = Qt.hsla(root._hue, 0.85, Colours.light ? 0.5 : 0.6, 1);
            if (root._isRegionKey(key)) {
                root._roMap[key] = c;
                root._roVersion++;
            } else if (root.hasOwnProperty(key)) {
                root[key] = c;
            }
        }
    }

    function highlight(key: string): void {
        // Toggle off — exit full preview
        if (highlightedToken === key) {
            exitPreview();
            return;
        }
        // Switching from another token — only restore color
        if (highlightedToken !== "")
            _restoreColor();
        // Validate key
        const valid = _isRegionKey(key) || root.hasOwnProperty(key);
        if (!valid) return;
        highlightedToken = key;
        _wasOverride = (_modeOverrides()).hasOwnProperty(key);
        _savedValue = _isRegionKey(key) ? _resolveRegionValue(key).toString() : root[key].toString();
        _hue = 0;
        const c = Qt.hsla(0, 0.85, Colours.light ? 0.5 : 0.6, 1);
        if (_isRegionKey(key)) {
            _roMap[key] = c;
            _roVersion++;
        } else {
            root[key] = c;
        }
        _rainbowTimer.start();
        // Enter preview mode (summon all, lock panels)
        if (!previewLocked)
            _enterPreview();
    }

    function _enterPreview(): void {
        const vis = Visibilities.getForActive();
        if (!vis) return;
        // Save current visibility state
        _savedVisState = {
            dashboard: vis.dashboard,
            launcher:  vis.launcher,
            utilities: vis.utilities,
            sidebar:   vis.sidebar,
            bar:       vis.bar
        };
        // Force everything open
        vis.dashboard = true;
        vis.utilities = true;
        vis.launcher  = true;
        vis.sidebar   = true;
        vis.bar       = true;
        previewLocked = true;
    }

    function exitPreview(): void {
        _restoreColor();
        _restoreVisibility();
        previewLocked = false;
    }

    function _restoreColor(): void {
        const key = highlightedToken;
        if (key === "") return;
        _rainbowTimer.stop();
        highlightedToken = "";
        if (_isRegionKey(key)) {
            if (_wasOverride)
                _roMap[key] = _savedValue;
            else
                delete _roMap[key];
            _roVersion++;
        } else {
            if (!root.hasOwnProperty(key)) return;
            if (_wasOverride)
                root[key] = _savedValue;
            else if (_defaultMap.hasOwnProperty(key))
                root[key] = Qt.binding(_defaultMap[key]);
        }
    }

    // Check if current highlight was an override (mode-aware)
    function _isCurrentOverride(key: string): bool {
        return (_modeOverrides()).hasOwnProperty(key);
    }

    function _restoreVisibility(): void {
        const vis = Visibilities.getForActive();
        if (!vis) return;
        vis.dashboard = _savedVisState.dashboard ?? false;
        vis.launcher  = _savedVisState.launcher  ?? false;
        vis.utilities = _savedVisState.utilities ?? false;
        vis.sidebar   = _savedVisState.sidebar   ?? false;
        vis.bar       = _savedVisState.bar       ?? false;
        _savedVisState = {};
    }

    function isHighlighted(key: string): bool {
        return highlightedToken === key;
    }

    // ═══════════════════════════════════════════════════════════
    // Bind all properties to Colours.palette after initialization
    // ═══════════════════════════════════════════════════════════
    Component.onCompleted: {
        applyModeFromConfig();
        _load();
        themeReady = true;
    }

    Connections {
        target: Config.appearance
        function onIsDarkChanged(): void {
            applyModeFromConfig();
        }
    }

    Connections {
        target: Colours
        function onCurrentLightChanged() {
            if (!root.themeReady)
                return;

            const shouldDark = !Colours.currentLight;
            if (root.isDark === shouldDark)
                return;

            root.isDark = shouldDark;
            _bindDefaults();
            _applyOverrides();
        }
    }

    Connections {
        target: Wallpapers
        function onActualCurrentChanged() {
            if (!Colours.dynamic) return;
            _bindDefaults();
            _applyOverrides();
        }
    }

    Connections {
        target: Colours
        function onDynamicChanged() {
            _bindDefaults();
            _applyOverrides();
        }
    }

    function _bindDefaults(): void {
        const bindings = _defaultMap;
        const ovr = _modeOverrides();
        for (const key of Object.keys(bindings)) {
            if (!ovr.hasOwnProperty(key))
                root[key] = Qt.binding(bindings[key]);
        }
        // Re-apply region overrides (palette changed, fallback bindings update automatically)
        _roVersion++;
    }

    // ═══════════════════════════════════════════════════════════
    // Metadata: token definitions for UI enumeration
    // ═══════════════════════════════════════════════════════════
    readonly property var tokenGroups: [
        {
            "group": "Accent",
            "icon": "palette",
            "tokens": [
                { "key": "accentPrimary", "label": qsTr("Primary accent"), "hint": qsTr("Buttons, switches, active indicators, links") },
                { "key": "accentSecondary", "label": qsTr("Secondary accent"), "hint": qsTr("Secondary buttons, chips, FAB") },
                { "key": "accentTertiary", "label": qsTr("Tertiary accent"), "hint": qsTr("Tertiary highlights, accent badges") },
                { "key": "fgAccentPrimary", "label": qsTr("On primary"), "hint": qsTr("Text/icon on primary colored surfaces") },
                { "key": "fgAccentSecondary", "label": qsTr("On secondary"), "hint": qsTr("Text/icon on secondary colored surfaces") },
                { "key": "fgAccentTertiary", "label": qsTr("On tertiary"), "hint": qsTr("Text/icon on tertiary colored surfaces") },
                { "key": "accentContainer", "label": qsTr("Accent container"), "hint": qsTr("Accent-tinted container background, action buttons") },
                { "key": "fgAccentContainer", "label": qsTr("On accent container"), "hint": qsTr("Text/icon on accent container surfaces") }
            ]
        },
        {
            "group": "Text",
            "icon": "format_color_text",
            "tokens": [
                { "key": "textPrimary", "label": qsTr("Primary text"), "hint": qsTr("Titles, headings, main body text") },
                { "key": "textSecondary", "label": qsTr("Secondary text"), "hint": qsTr("Subtitles, descriptions, secondary labels") },
                { "key": "textDisabled", "label": qsTr("Disabled text"), "hint": qsTr("Placeholder, disabled items, outlines") },
                { "key": "textOnAccent", "label": qsTr("Text on accent"), "hint": qsTr("Text on accent-colored buttons") }
            ]
        },
        {
            "group": "Surface",
            "icon": "layers",
            "tokens": [
                { "key": "surfaceBase", "label": qsTr("Base surface"), "hint": qsTr("Main window/page background") },
                { "key": "surfaceDim", "label": qsTr("Dim surface"), "hint": qsTr("Dimmed areas, inactive regions") },
                { "key": "surfaceBright", "label": qsTr("Bright surface"), "hint": qsTr("Elevated, highlighted areas") },
                { "key": "surfaceContainer", "label": qsTr("Container"), "hint": qsTr("Cards, list items, section backgrounds") },
                { "key": "surfaceContainerHigh", "label": qsTr("Container high"), "hint": qsTr("Elevated cards, active list items") },
                { "key": "surfaceContainerHighest", "label": qsTr("Container highest"), "hint": qsTr("Highest elevation cards, input fields") },
                { "key": "background", "label": qsTr("Background"), "hint": qsTr("Root-level background behind all content") },
                { "key": "fgBackground", "label": qsTr("On background"), "hint": qsTr("Text/icons on background color") }
            ]
        },
        {
            "group": "Bar",
            "icon": "dock_to_bottom",
            "tokens": [
                { "key": "barBackground", "label": qsTr("Background"), "hint": qsTr("Status bar background") },
                { "key": "barText", "label": qsTr("Text"), "hint": qsTr("Clock, workspace names in bar") },
                { "key": "barIcon", "label": qsTr("Icons"), "hint": qsTr("Tray icons, system icons in bar") },
                { "key": "barActiveIndicator", "label": qsTr("Active indicator"), "hint": qsTr("Active workspace dot, selected tab underline") },
                { "key": "barActiveText", "label": qsTr("Active text"), "hint": qsTr("Text on the active indicator") },
                { "key": "barBadge", "label": qsTr("Badge"), "hint": qsTr("Notification count badge in bar") }
            ]
        },
        {
            "group": "Media Lines",
            "icon": "waves",
            "tokens": [
                { "key": "mediaLinesPrimary", "label": qsTr("Primary"), "hint": qsTr("Main wave line color") },
                { "key": "mediaLinesSecondary", "label": qsTr("Secondary"), "hint": qsTr("Secondary wave line color") },
                { "key": "mediaLinesTertiary", "label": qsTr("Tertiary"), "hint": qsTr("Tertiary wave line color, used for mixed blending") }
            ]
        },
        {
            "group": "Launcher",
            "icon": "search",
            "tokens": [
                { "key": "launcherBackground", "label": qsTr("Background"), "hint": qsTr("App launcher popup background") },
                { "key": "launcherSearchBg", "label": qsTr("Search background"), "hint": qsTr("Search input field background") },
                { "key": "launcherSearchText", "label": qsTr("Search text"), "hint": qsTr("Typed text in search field") },
                { "key": "launcherItemText", "label": qsTr("Item text"), "hint": qsTr("App name in search results") },
                { "key": "launcherItemSubtext", "label": qsTr("Item subtext"), "hint": qsTr("App description, secondary info") },
                { "key": "launcherItemHover", "label": qsTr("Item hover"), "hint": qsTr("Hovered result item highlight") }
            ]
        },
        {
            "group": "Panel",
            "icon": "dashboard",
            "tokens": [
                { "key": "panelBackground", "label": qsTr("Background"), "hint": qsTr("Control center / sidebar background") },
                { "key": "panelSurface", "label": qsTr("Surface"), "hint": qsTr("Section cards inside the panel") },
                { "key": "panelSurfaceHigh", "label": qsTr("Surface elevated"), "hint": qsTr("Elevated sections, active toggles") },
                { "key": "panelText", "label": qsTr("Text"), "hint": qsTr("Titles, labels in control center") },
                { "key": "panelSubtext", "label": qsTr("Subtext"), "hint": qsTr("Descriptions, secondary info in panel") },
                { "key": "panelBorder", "label": qsTr("Border"), "hint": qsTr("Section borders, separators") },
                { "key": "panelDivider", "label": qsTr("Divider"), "hint": qsTr("Thin lines between list items") }
            ]
        },
        {
            "group": "Controls",
            "icon": "toggle_on",
            "tokens": [
                { "key": "buttonFilledBg", "label": qsTr("Filled button"), "hint": qsTr("Primary action buttons background") },
                { "key": "buttonFilledText", "label": qsTr("Filled button text"), "hint": qsTr("Text on primary action buttons") },
                { "key": "buttonTonalBg", "label": qsTr("Tonal button"), "hint": qsTr("Secondary / tonal button background") },
                { "key": "buttonTonalText", "label": qsTr("Tonal button text"), "hint": qsTr("Text on tonal buttons") },
                { "key": "buttonOutlineBorder", "label": qsTr("Outline border"), "hint": qsTr("Outline-style button borders") },
                { "key": "switchActive", "label": qsTr("Switch active"), "hint": qsTr("Enabled toggle switch track") },
                { "key": "switchInactive", "label": qsTr("Switch inactive"), "hint": qsTr("Disabled toggle switch track") },
                { "key": "sliderTrack", "label": qsTr("Slider track"), "hint": qsTr("Active portion of slider / progress") },
                { "key": "sliderInactive", "label": qsTr("Slider inactive"), "hint": qsTr("Inactive track portion of sliders") }
            ]
        },
        {
            "group": "Notifications",
            "icon": "notifications",
            "tokens": [
                { "key": "notifBackground", "label": qsTr("Background"), "hint": qsTr("Notification popup background") },
                { "key": "notifText", "label": qsTr("Title text"), "hint": qsTr("Notification title / app name") },
                { "key": "notifSubtext", "label": qsTr("Body text"), "hint": qsTr("Notification body / message content") },
                { "key": "notifActionBg", "label": qsTr("Action button"), "hint": qsTr("Reply, dismiss action buttons") },
                { "key": "notifActionText", "label": qsTr("Action text"), "hint": qsTr("Text on notification action buttons") },
                { "key": "notifUrgentBorder", "label": qsTr("Urgent border"), "hint": qsTr("Border highlight for urgent notifications") }
            ]
        },
        {
            "group": "Status",
            "icon": "info",
            "tokens": [
                { "key": "errorColor", "label": qsTr("Error"), "hint": qsTr("Error indicators, destructive actions") },
                { "key": "fgError", "label": qsTr("On error"), "hint": qsTr("Text/icon on error colored surfaces") },
                { "key": "errorContainer", "label": qsTr("Error container"), "hint": qsTr("Error message background / banner") },
                { "key": "fgErrorContainer", "label": qsTr("On error container"), "hint": qsTr("Text inside error banners") },
                { "key": "successColor", "label": qsTr("Success"), "hint": qsTr("Success indicators, confirmations") },
                { "key": "fgSuccess", "label": qsTr("On success"), "hint": qsTr("Text/icon on success surfaces") },
                { "key": "successContainer", "label": qsTr("Success container"), "hint": qsTr("Success message background") },
                { "key": "fgSuccessContainer", "label": qsTr("On success container"), "hint": qsTr("Text inside success banners") }
            ]
        }
    ]

    // ═══════════════════════════════════════════════════════════
    // Curated region tokens — only verified-visible components
    // (dashboard & controlcenter skipped for now)
    // ═══════════════════════════════════════════════════════════
    readonly property var curatedRegionTokens: [
        {
            group: "左侧 Bar",
            icon: "dock_to_left",
            tokens: [
                { key: "bar.chrome.surface.background",   label: "Bar 面板背景",          hint: "整个 bar 的底色" },
                { key: "bar.chrome.foreground.icon",       label: "系统图标",              hint: "系统图标、托盘图标、状态图标共用" },
                { key: "bar.chrome.foreground.text",       label: "工作区文字",            hint: "工作区编号、设置按钮图标" },
                { key: "bar.chrome.foreground.disabled",   label: "未激活工作区文字",      hint: "未占用工作区的淡色文字" },
                { key: "bar.chrome.accent.primary",        label: "电源按钮",              hint: "电源按钮图标颜色" },
                { key: "bar.chrome.accent.tertiary",       label: "特殊工作区强调色",      hint: "scratchpad 等特殊工作区的高亮背景" },
                { key: "bar.chrome.accent.onTertiary",     label: "特殊工作区前景",        hint: "特殊工作区高亮上的文字/图标" },
                { key: "bar.workspace.container.surface",  label: "工作区容器背景",        hint: "工作区列表、托盘图标、状态图标的容器" },
                { key: "bar.workspace.container.surfaceHigh", label: "占用工作区高亮",     hint: "有窗口的工作区组 pill 背景" },
                { key: "bar.workspace.active.indicator",   label: "当前工作区高亮",        hint: "当前工作区高亮背景色（同时也是时钟颜色）" },
                { key: "bar.workspace.active.text",        label: "当前工作区前景",        hint: "当前工作区内的文字/图标" },
                { key: "bar.media.primary",                label: "MediaOrb 主色",         hint: "MediaOrb 渐变主颜色" },
                { key: "bar.media.secondary",              label: "MediaOrb 辅色",         hint: "MediaOrb 渐变辅颜色" }
            ]
        },
        {
            group: "Launcher",
            icon: "search",
            tokens: [
                { key: "launcher.canvas.surface.background", label: "背景",              hint: "launcher 整体背景" },
                { key: "launcher.app.item.highlight",        label: "选中软件高亮",        hint: "当前选中应用的高亮矩形" },
                { key: "launcher.app.item.description",      label: "软件描述",            hint: "应用描述/副标题文字颜色" },
                { key: "launcher.search.field.bg",           label: "搜索栏背景",          hint: "底部搜索栏背景色" },
                { key: "launcher.search.field.icon",         label: "搜索栏图标",          hint: "搜索栏搜索图标颜色" },
                { key: "launcher.search.field.clear",        label: "搜索栏清除图标",      hint: "搜索栏清除按钮颜色" }
            ]
        },
        {
            group: "Utilities",
            icon: "build",
            tokens: [
                { key: "utilities.canvas.surface.background",       label: "大背景",                    hint: "utilities 面板整体背景" },
                { key: "utilities.cards.record.container.surface",   label: "截图区域背景",              hint: "录屏/截图卡片圆角矩形背景" },
                { key: "utilities.cards.record.status.mutedBg",     label: "截图图标背景",              hint: "截图图标的圆形背景色" },
                { key: "utilities.cards.record.status.mutedIcon",   label: "截图图标色",                hint: "截图 icon 颜色" },
                { key: "utilities.cards.record.status.activeBg",    label: "截图高亮背景",              hint: "录制激活时图标背景" },
                { key: "utilities.cards.record.status.activeIcon",  label: "截图高亮图标色",            hint: "录制激活时图标颜色" },
                { key: "utilities.cards.record.subtitle",           label: "截图文字",                  hint: "录屏/截图副标题文字色" },
                { key: "utilities.cards.record.destructive.bg",     label: "截图停止按钮背景",          hint: "录制停止按钮背景色" },
                { key: "utilities.cards.record.destructive.fg",     label: "截图停止按钮文字",          hint: "录制停止按钮文字色" },
                { key: "utilities.card.container.surface",          label: "音频/亮度/Toggle 卡片背景", hint: "滑块与 Toggle 区域共用的卡片底色" },
                { key: "utilities.slider.thumb.icon",               label: "音频/亮度图标",             hint: "音量/亮度图标颜色" },
                { key: "shared.controls.slider.track",              label: "音量/亮度滑块色",           hint: "滑块活跃轨道颜色（全局共用控件色）" },
                { key: "shared.controls.slider.inactive",           label: "音量/亮度滑块底色",         hint: "滑块非活跃轨道颜色（全局共用控件色）" },
                { key: "utilities.toggle.activeBg",                 label: "Quick Toggle 高亮背景",     hint: "toggle 激活时的 pill 背景" },
                { key: "utilities.toggle.activeIcon",               label: "Quick Toggle 高亮图标",     hint: "toggle 激活时的图标颜色" },
                { key: "utilities.toggle.inactiveBg",               label: "Quick Toggle 图标背景",     hint: "toggle 未激活时的 pill 背景" },
                { key: "utilities.toggle.inactiveIcon",             label: "Quick Toggle 图标色",       hint: "toggle 未激活时的图标颜色" },
                { key: "utilities.toggle.state.labelInactive",      label: "Quick Toggle 文字",         hint: "toggle 非活跃状态文字" },
                { key: "utilities.toggle.state.pillInactive",       label: "Quick Toggle 非活跃pill",   hint: "toggle 非活跃时的 pill 背景色" }
            ]
        }
    ]

    // (regionTokenPaths and regionTokenTree removed — replaced by curatedRegionTokens)

    // ═══════════════════════════════════════════════════════════
    // Override tracking — per-wallpaper / global isolation
    // Structure: { global: {light:{}, dark:{}},
    //              wallpapers: { "file.jpg": {light:{}, dark:{}}, … } }
    // ═══════════════════════════════════════════════════════════
    property var _allData: ({ "global": { "light": {}, "dark": {} }, "wallpapers": {} })

    function _wallpaperKey(): string {
        const p = Wallpapers.actualCurrent;
        if (!p) return "";
        const idx = p.lastIndexOf("/");
        return idx >= 0 ? p.substring(idx + 1) : p;
    }

    function _modeKey(): string {
        return isDark ? "dark" : "light";
    }

    function _currentBucket(): var {
        if (!Colours.dynamic)
            return _allData.global;
        const wk = _wallpaperKey();
        if (!wk) return _allData.global;
        if (!_allData.wallpapers[wk])
            _allData.wallpapers[wk] = { "light": {}, "dark": {} };
        return _allData.wallpapers[wk];
    }

    function _modeOverrides(): var {
        const bucket = _currentBucket();
        const mk = _modeKey();
        if (!bucket[mk]) bucket[mk] = {};
        return bucket[mk];
    }

    function _isRegionKey(key: string): bool {
        return key.indexOf(".") >= 0;
    }

    function setColor(key: string, color: color): void {
        if (_isRegionKey(key)) {
            // Region-level override: store in _roMap and bump version
            _roMap[key] = color;
            _roVersion++;
        } else {
            // Root-level: set property directly
            if (!root.hasOwnProperty(key)) return;
            root[key] = color;
        }
        _modeOverrides()[key] = color.toString();
        _saveTimer.restart();
    }

    function resetColor(key: string): void {
        const ovr = _modeOverrides();
        if (!ovr.hasOwnProperty(key)) return;
        delete ovr[key];
        if (_isRegionKey(key)) {
            // Region-level: remove from _roMap and bump version
            delete _roMap[key];
            _roVersion++;
        } else if (_defaultMap.hasOwnProperty(key)) {
            root[key] = Qt.binding(_defaultMap[key]);
        }
        _saveTimer.restart();
    }

    function resetAll(): void {
        const ovr = _modeOverrides();
        const keys = Object.keys(ovr);
        const bucket = _currentBucket();
        bucket[_modeKey()] = {};
        // Reset root-level tokens
        for (const key of keys) {
            if (_isRegionKey(key)) {
                delete _roMap[key];
            } else if (_defaultMap.hasOwnProperty(key)) {
                root[key] = Qt.binding(_defaultMap[key]);
            }
        }
        if (keys.some(k => _isRegionKey(k)))
            _roVersion++;
        _saveTimer.restart();
    }

    function saveAsGlobal(): void {
        const mode = _modeKey();
        if (!_allData.global[mode])
            _allData.global[mode] = {};
        const target = _allData.global[mode];
        // Snapshot root-level tokens
        for (const key of Object.keys(_defaultMap)) {
            if (root.hasOwnProperty(key))
                target[key] = root[key].toString();
        }
        // Snapshot region-level overrides
        for (const [path, val] of Object.entries(_roMap)) {
            target[path] = val.toString();
        }
        _saveTimer.restart();
        console.log("[ComponentColors] Saved current colors as global defaults (" + mode + ")");
    }

    function isOverridden(key: string): bool {
        return (_modeOverrides()).hasOwnProperty(key);
    }

    function getColor(key: string): color {
        if (_isRegionKey(key))
            return _resolveRegionValue(key);
        if (!root.hasOwnProperty(key)) return "#FF00FF";
        return root[key];
    }

    // ═══════════════════════════════════════════════════════════
    // Default value map (for binding to Colours.palette)
    // ═══════════════════════════════════════════════════════════
    readonly property var _defaultMap: ({
        "accentPrimary": () => Colours.palette.m3primary,
        "accentSecondary": () => Colours.palette.m3secondary,
        "accentTertiary": () => Colours.palette.m3tertiary,
        "fgAccentPrimary": () => "#FFFFFF",
        "fgAccentSecondary": () => Colours.palette.m3onSecondary,
        "fgAccentTertiary": () => Colours.palette.m3onTertiary,
        "accentContainer": () => Colours.palette.m3primaryContainer,
        "fgAccentContainer": () => Colours.palette.m3onPrimaryContainer,
        "inversePrimary": () => Colours.palette.m3inversePrimary,
        "tertiaryContainer": () => Colours.palette.m3tertiaryContainer,
        "fgTertiaryContainer": () => Colours.palette.m3onTertiaryContainer,
        "textPrimary": () => Colours.palette.m3onSurface,
        "textSecondary": () => Colours.palette.m3onSurfaceVariant,
        "textDisabled": () => Colours.palette.m3outline,
        "textOnAccent": () => "#FFFFFF",
        "surfaceBase": () => Colours.palette.m3surface,
        "surfaceDim": () => Colours.palette.m3surfaceDim,
        "surfaceBright": () => Colours.palette.m3surfaceBright,
        "surfaceContainer": () => Colours.palette.m3surfaceContainer,
        "surfaceContainerLow": () => Colours.palette.m3surfaceContainerLow,
        "surfaceContainerHigh": () => Colours.palette.m3surfaceContainerHigh,
        "surfaceContainerHighest": () => Colours.palette.m3surfaceContainerHighest,
        "background": () => Colours.palette.m3background,
        "fgBackground": () => Colours.palette.m3onBackground,
        "barBackground": () => Colours.palette.m3surface,
        "barText": () => Colours.palette.m3onSurface,
        "barIcon": () => Colours.palette.m3onSurfaceVariant,
        "barActiveIndicator": () => Colours.palette.m3primary,
        "barActiveText": () => Colours.palette.m3onPrimary,
        "barBadge": () => Colours.palette.m3error,
        "mediaLinesPrimary": () => Colours.palette.m3primary,
        "mediaLinesSecondary": () => Colours.palette.m3secondary,
        "mediaLinesTertiary": () => Colours.palette.m3tertiary,
        "launcherBackground": () => Colours.palette.m3surface,
        "launcherSearchBg": () => Colours.palette.m3surfaceContainer,
        "launcherSearchText": () => Colours.palette.m3onSurface,
        "launcherItemText": () => Colours.palette.m3onSurface,
        "launcherItemSubtext": () => Colours.palette.m3outline,
        "launcherItemHover": () => Colours.palette.m3secondaryContainer,
        "panelBackground": () => Colours.palette.m3surface,
        "panelSurface": () => Colours.palette.m3surfaceContainer,
        "panelSurfaceHigh": () => Colours.palette.m3surfaceContainerHigh,
        "panelText": () => Colours.palette.m3onSurface,
        "panelSubtext": () => Colours.palette.m3onSurfaceVariant,
        "panelBorder": () => Colours.palette.m3outline,
        "panelDivider": () => Colours.palette.m3outlineVariant,
        "buttonFilledBg": () => Colours.palette.m3primary,
        "buttonFilledText": () => Colours.palette.m3onPrimary,
        "buttonTonalBg": () => Colours.palette.m3secondaryContainer,
        "buttonTonalText": () => Colours.palette.m3onSecondaryContainer,
        "buttonOutlineBorder": () => Colours.palette.m3outline,
        "switchActive": () => Colours.palette.m3primary,
        "switchInactive": () => Colours.palette.m3surfaceContainerHighest,
        "sliderTrack": () => Colours.palette.m3primary,
        "sliderInactive": () => Colours.palette.m3surfaceContainerHighest,
        "notifBackground": () => Colours.palette.m3surface,
        "notifText": () => Colours.palette.m3onSurface,
        "notifSubtext": () => Colours.palette.m3onSurfaceVariant,
        "notifActionBg": () => Colours.palette.m3secondaryContainer,
        "notifActionText": () => Colours.palette.m3onSecondaryContainer,
        "notifUrgentBorder": () => Colours.palette.m3error,
        "errorColor": () => Colours.palette.m3error,
        "fgError": () => Colours.palette.m3onError,
        "errorContainer": () => Colours.palette.m3errorContainer,
        "fgErrorContainer": () => Colours.palette.m3onErrorContainer,
        "successColor": () => Colours.palette.m3success,
        "fgSuccess": () => Colours.palette.m3onSuccess,
        "successContainer": () => Colours.palette.m3successContainer,
        "fgSuccessContainer": () => Colours.palette.m3onSuccessContainer,
        "scrim": () => Colours.palette.m3scrim,
        "shadow": () => Colours.palette.m3shadow
    })

    // ═══════════════════════════════════════════════════════════
    // Persistence
    // ═══════════════════════════════════════════════════════════
    Timer {
        id: _saveTimer
        interval: 500
        onTriggered: _save()
    }

    function _save(): void {
        try {
            _fileView.setText(JSON.stringify(_allData, null, 2));
        } catch (e) {
            console.error("[ComponentColors] Failed to save:", e.message);
        }
    }

    function _load(): void {
        try {
            const text = _fileView.text();
            if (!text || text.trim() === "" || text.trim() === "{}")
                return;

            const data = JSON.parse(text);

            // Migration: old flat {light:{}, dark:{}} → new structure
            if (data.hasOwnProperty("global")) {
                _allData = data;
            } else if (data.hasOwnProperty("light") || data.hasOwnProperty("dark")) {
                _allData = { "global": { "light": data.light ?? {}, "dark": data.dark ?? {} }, "wallpapers": {} };
            } else {
                _allData = { "global": { "light": data, "dark": {} }, "wallpapers": {} };
            }
        } catch (e) {
            console.error("[ComponentColors] Failed to load:", e.message);
            return;
        }
        _applyOverrides();
    }

    function _applyOverrides(): void {
        // Clear old region overrides
        _roMap = {};
        const ovr = _modeOverrides();
        for (const [key, value] of Object.entries(ovr)) {
            if (_isRegionKey(key)) {
                _roMap[key] = value;
            } else if (root.hasOwnProperty(key)) {
                root[key] = value;
            }
        }
        _roVersion++;
    }

    FileView {
        id: _fileView
        path: `${Paths.config}/colors.json`
        watchChanges: false
    }
}
