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
    // Region Tokens (phase-1 foundation)
    // ═══════════════════════════════════════════════════════════
    readonly property RegionTokens region: RegionTokens {}

    component RegionTokens: QtObject {
        readonly property BarRegion bar: BarRegion {}
        readonly property UtilitiesRegion utilities: UtilitiesRegion {}
        readonly property LauncherRegion launcher: LauncherRegion {}
        readonly property PanelRegion panel: PanelRegion {}
        readonly property NotificationRegion notification: NotificationRegion {}
        readonly property DashboardRegion dashboard: DashboardRegion {}
        readonly property LockRegion lock: LockRegion {}
        readonly property SidebarRegion sidebar: SidebarRegion {}
        readonly property BackgroundRegion background: BackgroundRegion {}
        readonly property StatePalette state: StatePalette {}
    }

    component StatePalette: QtObject {
        readonly property color error: root.errorColor
        readonly property color onError: root.fgError
        readonly property color errorContainer: root.errorContainer
        readonly property color onErrorContainer: root.fgErrorContainer
        readonly property color success: root.successColor
        readonly property color onSuccess: root.fgSuccess
        readonly property color successContainer: root.successContainer
        readonly property color onSuccessContainer: root.fgSuccessContainer
        readonly property color warning: root.accentSecondary
        readonly property color onWarning: root.fgAccentSecondary
        readonly property color warningContainer: root.buttonTonalBg
        readonly property color onWarningContainer: root.buttonTonalText
        readonly property color scrim: root.scrim
        readonly property color shadow: root.shadow
    }

    component BarRegion: QtObject {
        readonly property color background: root.barBackground
        readonly property color text: root.barText
        readonly property color icon: root.barIcon
        readonly property color disabledText: root.textDisabled

        readonly property color accent: root.accentPrimary
        readonly property color onAccent: root.fgAccentPrimary
        readonly property color accentContainer: root.accentContainer
        readonly property color onAccentContainer: root.fgAccentContainer
        readonly property color accentTertiary: root.accentTertiary
        readonly property color onAccentTertiary: root.fgAccentTertiary

        readonly property QtObject workspace: QtObject {
            readonly property color surface: root.surfaceContainer
            readonly property color surfaceHigh: root.surfaceContainerHigh
            readonly property color activeIndicator: root.barActiveIndicator
            readonly property color activeText: root.barActiveText
        }

        readonly property QtObject popout: QtObject {
            readonly property color surface: root.surfaceContainer
            readonly property color text: root.textPrimary
            readonly property color subtext: root.textSecondary
            readonly property color divider: root.panelDivider

            readonly property QtObject button: QtObject {
                readonly property color bg: root.buttonTonalBg
                readonly property color text: root.buttonTonalText
            }
        }

        readonly property QtObject media: QtObject {
            readonly property color primary: root.mediaLinesPrimary
            readonly property color secondary: root.mediaLinesSecondary
            readonly property color tertiary: root.mediaLinesTertiary
        }
    }

    component LauncherRegion: QtObject {
        readonly property color background: root.launcherBackground

        readonly property QtObject search: QtObject {
            readonly property color bg: root.launcherSearchBg
            readonly property color icon: root.launcherItemSubtext
            readonly property color clear: root.launcherItemSubtext
        }

        readonly property QtObject app: QtObject {
            readonly property color highlight: root.launcherItemText
            readonly property color description: root.launcherItemSubtext
        }

        readonly property QtObject emptyState: QtObject {
            readonly property color icon: root.launcherItemSubtext
            readonly property color title: root.launcherItemSubtext
            readonly property color subtitle: root.launcherItemSubtext
        }

        readonly property QtObject calc: QtObject {
            readonly property color placeholder: root.launcherItemSubtext
            readonly property color result: root.launcherItemText
            readonly property color buttonBg: root.accentPrimary
            readonly property color buttonText: root.fgAccentPrimary
        }

        readonly property QtObject wallpaper: QtObject {
            readonly property color placeholder: root.launcherSearchBg
            readonly property color icon: root.launcherItemSubtext
        }
    }

    component PanelRegion: QtObject {
        readonly property color surface: root.surfaceContainer
        readonly property color surfaceHigh: root.surfaceContainerHigh
        readonly property color surfaceHighest: root.surfaceContainerHighest
        readonly property color surfaceBase: root.surfaceBase
        readonly property color surfaceBright: root.surfaceBright
        readonly property color text: root.textPrimary
        readonly property color subtext: root.textSecondary
        readonly property color textDisabled: root.textDisabled
        readonly property color border: root.panelBorder

        readonly property color accent: root.accentPrimary
        readonly property color onAccent: root.fgAccentPrimary
        readonly property color accentSecondary: root.accentSecondary
        readonly property color onAccentSecondary: root.fgAccentSecondary
        readonly property color accentContainer: root.accentContainer
        readonly property color onAccentContainer: root.fgAccentContainer

        readonly property QtObject button: QtObject {
            readonly property color tonalBg: root.buttonTonalBg
            readonly property color tonalText: root.buttonTonalText
            readonly property color filledBg: root.buttonFilledBg
            readonly property color filledText: root.buttonFilledText
        }

        readonly property QtObject toggle: QtObject {
            readonly property color active: root.switchActive
            readonly property color inactive: root.switchInactive
            readonly property color thumb: root.fgAccentPrimary
        }

        readonly property QtObject slider: QtObject {
            readonly property color track: root.sliderTrack
            readonly property color inactive: root.sliderInactive
        }
    }

    component NotificationRegion: QtObject {
        readonly property color background: root.notifBackground

        readonly property QtObject card: QtObject {
            readonly property color normal: root.surfaceContainer
            readonly property color critical: root.notifActionBg
        }

        readonly property QtObject badge: QtObject {
            readonly property color critical: root.notifUrgentBorder
            readonly property color normal: root.notifActionBg
            readonly property color low: root.notifActionBg
        }

        readonly property QtObject appIcon: QtObject {
            readonly property color critical: root.fgError
            readonly property color normal: root.notifActionText
            readonly property color low: root.notifText
        }

        readonly property color appName: root.notifSubtext
        readonly property color time: root.notifSubtext
        readonly property color body: root.notifSubtext

        readonly property QtObject expand: QtObject {
            readonly property color critical: root.notifActionText
            readonly property color normal: root.notifText
        }

        readonly property QtObject action: QtObject {
            readonly property color normalBg: root.notifActionBg
            readonly property color criticalBg: root.notifUrgentBorder
            readonly property color normalText: root.notifSubtext
            readonly property color criticalText: root.fgAccentSecondary
            readonly property color normalStateLayer: root.notifText
            readonly property color criticalStateLayer: root.fgAccentSecondary
        }

        readonly property QtObject indicator: QtObject {
            readonly property color bg: root.accentTertiary
            readonly property color text: root.fgAccentTertiary
        }
    }

    component DashboardRegion: QtObject {
        readonly property color background: root.panelBackground

        readonly property QtObject card: QtObject {
            readonly property color surface: root.surfaceContainer
        }

        readonly property QtObject tabs: QtObject {
            readonly property color indicator: root.accentPrimary
            readonly property color divider: root.panelDivider
            readonly property color activeIcon: root.accentPrimary
            readonly property color activeLabel: root.accentPrimary
            readonly property color inactiveIcon: root.textSecondary
            readonly property color inactiveLabel: root.textSecondary
        }

        readonly property QtObject calendar: QtObject {
            readonly property color nav: root.accentTertiary
            readonly property color monthYear: root.accentPrimary
            readonly property QtObject dayOfWeek: QtObject {
                readonly property color weekday: root.textSecondary
                readonly property color weekend: root.accentSecondary
            }
            readonly property QtObject day: QtObject {
                readonly property color weekday: root.textSecondary
                readonly property color weekend: root.accentSecondary
                readonly property color todayBg: root.accentPrimary
                readonly property color todayText: root.fgAccentPrimary
                readonly property color todaySourceColor: root.textPrimary
            }
        }

        readonly property QtObject dateTime: QtObject {
            readonly property color hours: root.accentSecondary
            readonly property color minutes: root.accentSecondary
            readonly property color separator: root.accentPrimary
            readonly property color amPm: root.accentPrimary
        }

        readonly property QtObject user: QtObject {
            readonly property QtObject avatar: QtObject {
                readonly property color background: root.surfaceContainerHigh
                readonly property color selectBg: root.accentPrimary
                readonly property color selectIcon: root.fgAccentPrimary
            }
            readonly property QtObject info: QtObject {
                readonly property color osIcon: root.accentPrimary
                readonly property color wmIcon: root.accentSecondary
                readonly property color uptimeIcon: root.accentTertiary
            }
        }

        readonly property QtObject weather: QtObject {
            readonly property color city: root.textPrimary
            readonly property color date: root.textSecondary
            readonly property color card: root.surfaceContainer
            readonly property color mainIcon: root.accentPrimary
            readonly property color temperature: root.accentPrimary
            readonly property color description: root.textSecondary
            readonly property color sunriseSunset: root.accentPrimary
            readonly property QtObject detail: QtObject {
                readonly property color card: root.surfaceContainer
                readonly property color icon: root.accentPrimary
            }
            readonly property QtObject stat: QtObject {
                readonly property color label: root.textSecondary
                readonly property color value: root.textPrimary
            }
            readonly property QtObject forecast: QtObject {
                readonly property color heading: root.textPrimary
                readonly property color card: root.surfaceContainer
                readonly property color day: root.textPrimary
                readonly property color date: root.textSecondary
                readonly property color icon: root.accentPrimary
                readonly property color temps: root.textPrimary
            }
        }

        readonly property QtObject dashWeather: QtObject {
            readonly property color icon: root.accentSecondary
            readonly property color temperature: root.accentPrimary
        }

        readonly property QtObject media: QtObject {
            readonly property QtObject cover: QtObject {
                readonly property color core: root.accentPrimary
                readonly property color fade: root.surfaceBase
            }
            readonly property QtObject title: QtObject {
                readonly property color active: root.accentPrimary
                readonly property color inactive: root.textPrimary
            }
            readonly property color album: root.panelBorder
            readonly property QtObject artist: QtObject {
                readonly property color active: root.accentSecondary
                readonly property color inactive: root.panelBorder
            }
            readonly property QtObject controls: QtObject {
                readonly property color playPause: root.accentPrimary
                readonly property color playPauseBg: root.surfaceContainer
                readonly property color skip: root.textSecondary
                readonly property color raise: root.accentSecondary
                readonly property color disabled: root.panelBorder
            }
            readonly property color position: root.textSecondary
            readonly property color length: root.textSecondary
            readonly property QtObject visualiser: QtObject {
                readonly property color baseline: root.accentTertiary
                readonly property color barDim: root.accentTertiary
                readonly property color barBright: root.accentPrimary
            }
        }

        readonly property QtObject dashMedia: QtObject {
            readonly property QtObject cover: QtObject {
                readonly property color core: root.accentPrimary
                readonly property color fade: root.surfaceBase
            }
            readonly property color title: root.accentPrimary
            readonly property color album: root.panelBorder
            readonly property color artist: root.accentSecondary
            readonly property QtObject controls: QtObject {
                readonly property color playPause: root.accentPrimary
                readonly property color skip: root.textSecondary
                readonly property color disabled: root.panelBorder
            }
            readonly property QtObject visualiser: QtObject {
                readonly property color baseline: root.accentTertiary
                readonly property color barDim: root.accentTertiary
                readonly property color barBright: root.accentPrimary
            }
        }

        readonly property QtObject performance: QtObject {
            readonly property QtObject arc: QtObject {
                readonly property color fg1: root.accentPrimary
                readonly property color fg2: root.accentSecondary
                readonly property color bg1: root.accentContainer
                readonly property color bg2: root.buttonTonalBg
            }
            readonly property color sublabel: root.textSecondary
        }

        readonly property QtObject dashResources: QtObject {
            readonly property color cpu: root.accentPrimary
            readonly property color memory: root.accentSecondary
            readonly property color storage: root.accentTertiary
            readonly property color progressTrack: root.surfaceContainerHigh
        }
    }

    component LockRegion: QtObject {
        readonly property color background: root.barBackground
        readonly property color surface: root.surfaceContainer
        readonly property color surfaceHigh: root.surfaceContainerHigh
        readonly property color surfaceHighest: root.surfaceContainerHighest
        readonly property color text: root.textPrimary
        readonly property color subtext: root.textSecondary
        readonly property color disabledText: root.textDisabled
        readonly property color accent: root.accentPrimary
        readonly property color onAccent: root.fgAccentPrimary
        readonly property color accentSecondary: root.accentSecondary
        readonly property color accentTertiary: root.accentTertiary
        readonly property color border: root.panelBorder
        readonly property color divider: root.panelDivider

        readonly property QtObject notif: QtObject {
            readonly property color bg: root.buttonTonalBg
            readonly property color text: root.buttonTonalText
        }

        readonly property QtObject wave: QtObject {
            readonly property color primary: root.mediaLinesPrimary
            readonly property color secondary: root.mediaLinesSecondary
            readonly property color tertiary: root.mediaLinesTertiary
        }
    }

    component SidebarRegion: QtObject {
        readonly property color background: root.panelBackground

        readonly property QtObject container: QtObject {
            readonly property color surface: root.surfaceContainerLow
            readonly property color divider: root.panelDivider
        }

        readonly property QtObject dock: QtObject {
            readonly property color count: root.panelBorder
            readonly property color title: root.panelBorder
            readonly property color emptyIcon: root.panelDivider
            readonly property color emptyText: root.panelDivider
        }

        readonly property QtObject group: QtObject {
            readonly property color surface: root.surfaceContainer
            readonly property color appName: root.textSecondary
            readonly property color time: root.panelBorder

            readonly property QtObject icon: QtObject {
                readonly property color critical: root.fgError
                readonly property color normal: root.buttonTonalText
                readonly property color low: root.textPrimary
            }

            readonly property QtObject badge: QtObject {
                readonly property color criticalBg: root.errorColor
                readonly property color normalBg: root.buttonTonalBg
                readonly property color lowBg: root.surfaceContainerHigh
            }

            readonly property QtObject counter: QtObject {
                readonly property color criticalBg: root.errorColor
                readonly property color normalBg: root.surfaceContainerHigh
                readonly property color criticalText: root.fgError
                readonly property color normalText: root.textPrimary
            }
        }

        readonly property QtObject notif: QtObject {
            readonly property color criticalBg: root.buttonTonalBg
            readonly property color normalBg: root.surfaceContainerHigh
            readonly property color criticalText: root.buttonTonalText
            readonly property color normalText: root.textPrimary
            readonly property color criticalBody: root.accentSecondary
            readonly property color normalBody: root.panelBorder
            readonly property color time: root.panelBorder
        }

        readonly property QtObject action: QtObject {
            readonly property color surface: root.surfaceContainerHighest
            readonly property color text: root.textSecondary
        }
    }

    component BackgroundRegion: QtObject {
        readonly property QtObject visualiser: QtObject {
            readonly property color bars: root.accentPrimary
            readonly property color glow: root.inversePrimary
        }
        readonly property QtObject wallpaper: QtObject {
            readonly property color placeholder: root.surfaceContainer
            readonly property color icon: root.textSecondary
            readonly property color retryBg: root.accentPrimary
            readonly property color retryIcon: root.fgAccentPrimary
        }
        readonly property QtObject clock: QtObject {
            readonly property color hours: root.accentPrimary
            readonly property color minutes: root.accentSecondary
            readonly property color separator: root.accentTertiary
            readonly property color dateBg: root.surfaceBase
        }
    }

    component UtilitiesRegion: QtObject {
        readonly property color background: root.surfaceBase

        readonly property QtObject card: QtObject {
            readonly property color surface: root.surfaceContainer
            readonly property color surfaceHigh: root.surfaceContainerHigh
            readonly property color surfaceHighest: root.surfaceContainerHighest
            readonly property color border: root.panelBorder
            readonly property color label: root.textSecondary
            readonly property color icon: root.barIcon
            readonly property color text: root.textSecondary

            readonly property QtObject status: QtObject {
                readonly property color activeBg: root.accentSecondary
                readonly property color activeIcon: root.fgAccentSecondary
                readonly property color mutedBg: root.buttonTonalBg
                readonly property color mutedIcon: root.buttonTonalText
            }
        }

        readonly property QtObject toggle: QtObject {
            readonly property color activeBg: root.accentSecondary
            readonly property color activeIcon: root.fgAccentSecondary
            readonly property color inactiveBg: root.buttonTonalBg
            readonly property color inactiveIcon: root.buttonTonalText
            readonly property color label: root.textSecondary
            readonly property color labelInactive: root.textSecondary
            readonly property color pillInactive: root.surfaceContainerHighest
            readonly property color surface: root.surfaceContainerHighest
        }

        readonly property QtObject slider: QtObject {
            readonly property color icon: root.textSecondary
        }

        readonly property QtObject action: QtObject {
            readonly property color accent: root.accentPrimary
            readonly property color onAccent: root.fgAccentPrimary
        }

        readonly property QtObject toast: QtObject {
            readonly property color defaultBg: root.surfaceBase
            readonly property color warningBg: root.accentSecondary
            readonly property color defaultBorder: root.panelDivider
            readonly property color warningBorder: root.accentSecondary
            readonly property color defaultIconBg: root.surfaceContainerHigh
            readonly property color defaultIconFg: root.textSecondary
            readonly property color warningIconBg: root.buttonTonalBg
            readonly property color warningIconFg: root.buttonTonalText
            readonly property color defaultTitle: root.textPrimary
            readonly property color warningTitle: root.fgAccentSecondary
            readonly property color defaultBody: root.textSecondary
            readonly property color warningBody: root.fgAccentSecondary
        }

        readonly property QtObject modal: QtObject {
            readonly property color scrim: root.scrim
            readonly property color surface: root.surfaceContainerHigh
            readonly property color text: root.textSecondary
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
            if (key !== "" && root.hasOwnProperty(key))
                root[key] = Qt.hsla(root._hue, 0.85, Colours.light ? 0.5 : 0.6, 1);
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
        // Activate rainbow on new token
        if (!root.hasOwnProperty(key)) return;
        highlightedToken = key;
        _wasOverride = (_modeOverrides()).hasOwnProperty(key);
        _savedValue = root[key].toString();
        _hue = 0;
        root[key] = Qt.hsla(0, 0.85, Colours.light ? 0.5 : 0.6, 1);
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
        if (!root.hasOwnProperty(key)) return;
        if (_wasOverride)
            root[key] = _savedValue;
        else if (_defaultMap.hasOwnProperty(key))
            root[key] = Qt.binding(_defaultMap[key]);
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

    function setColor(key: string, color: color): void {
        if (!root.hasOwnProperty(key)) return;
        root[key] = color;
        _modeOverrides()[key] = color.toString();
        _saveTimer.restart();
    }

    function resetColor(key: string): void {
        const ovr = _modeOverrides();
        if (!ovr.hasOwnProperty(key)) return;
        delete ovr[key];
        if (_defaultMap.hasOwnProperty(key))
            root[key] = Qt.binding(_defaultMap[key]);
        _saveTimer.restart();
    }

    function resetAll(): void {
        const ovr = _modeOverrides();
        const keys = Object.keys(ovr);
        const bucket = _currentBucket();
        bucket[_modeKey()] = {};
        for (const key of keys) {
            if (_defaultMap.hasOwnProperty(key))
                root[key] = Qt.binding(_defaultMap[key]);
        }
        _saveTimer.restart();
    }

    function saveAsGlobal(): void {
        const mode = _modeKey();
        if (!_allData.global[mode])
            _allData.global[mode] = {};
        const target = _allData.global[mode];
        // Snapshot all current color values into the global bucket
        for (const key of Object.keys(_defaultMap)) {
            if (root.hasOwnProperty(key))
                target[key] = root[key].toString();
        }
        _saveTimer.restart();
        console.log("[ComponentColors] Saved current colors as global defaults (" + mode + ")");
    }

    function isOverridden(key: string): bool {
        return (_modeOverrides()).hasOwnProperty(key);
    }

    function getColor(key: string): color {
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
        "fgAccentPrimary": () => Colours.palette.m3onPrimary,
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
        "textOnAccent": () => Colours.palette.m3onPrimary,
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
        const ovr = _modeOverrides();
        for (const [key, value] of Object.entries(ovr)) {
            if (root.hasOwnProperty(key))
                root[key] = value;
        }
    }

    FileView {
        id: _fileView
        path: `${Paths.config}/colors.json`
        watchChanges: false
    }
}
