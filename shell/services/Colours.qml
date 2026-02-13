pragma Singleton
pragma ComponentBehavior: Bound

import qs.config
import qs.utils
import Anachord
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool showPreview
    readonly property bool dynamic: Config.services.dynamicColors
    readonly property bool light: showPreview ? previewLight : currentLight
    property bool currentLight: true
    property bool previewLight
    readonly property M3Palette palette: showPreview ? preview : current
    readonly property M3TPalette tPalette: M3TPalette {}
    readonly property M3Palette current: M3Palette {}
    readonly property M3Palette preview: M3Palette {}
    readonly property M3Palette _defaults: M3Palette {}
    readonly property M3Palette _defaultsDark: M3Palette {
        // Palette keys (red gradient)
        m3primary_paletteKeyColor: "#C02828"
        m3secondary_paletteKeyColor: "#962020"
        m3tertiary_paletteKeyColor: "#6E1616"
        m3neutral_paletteKeyColor: "#282828"
        m3neutral_variant_paletteKeyColor: "#3a3a3a"

        // Surfaces: PURE neutral grey (S=0%), no red tint
        m3background: "#121212"
        m3onBackground: "#e3e3e3"
        m3surface: "#121212"
        m3surfaceDim: "#121212"
        m3surfaceBright: "#383838"
        m3surfaceContainerLowest: "#0a0a0a"
        m3surfaceContainerLow: "#1a1a1a"
        m3surfaceContainer: "#1e1e1e"
        m3surfaceContainerHigh: "#252525"
        m3surfaceContainerHighest: "#303030"
        m3onSurface: "#e3e3e3"
        m3surfaceVariant: "#444444"
        m3onSurfaceVariant: "#c0c0c0"
        m3inverseSurface: "#e3e3e3"
        m3inverseOnSurface: "#303030"

        // Outline: neutral grey
        m3outline: "#707070"
        m3outlineVariant: "#444444"

        // Shadow
        m3shadow: "#000000"
        m3scrim: "#000000"
        m3surfaceTint: "#C02828"

        // Primary accent: vivid blood red
        m3primary: "#C02828"
        m3onPrimary: "#FFFFFF"
        m3primaryContainer: "#2e2e2e"
        m3onPrimaryContainer: "#ddd0d0"
        m3inversePrimary: "#962020"

        // Secondary accent: deeper blood red
        m3secondary: "#962020"
        m3onSecondary: "#FFFFFF"
        m3secondaryContainer: "#2a2a2a"
        m3onSecondaryContainer: "#C02828"

        // Tertiary accent: darkest blood red
        m3tertiary: "#6E1616"
        m3onTertiary: "#e0dada"
        m3tertiaryContainer: "#242424"
        m3onTertiaryContainer: "#962020"

        // Error (matches primary)
        m3error: "#C02828"
        m3onError: "#FFFFFF"
        m3errorContainer: "#2e2e2e"
        m3onErrorContainer: "#ddd0d0"

        // Success: muted green
        m3success: "#5a7a5e"
        m3onSuccess: "#FFFFFF"
        m3successContainer: "#1a2a1e"
        m3onSuccessContainer: "#b8ccba"

        // Fixed: subtle dark reds (for chips, etc.)
        m3primaryFixed: "#333333"
        m3primaryFixedDim: "#2a2a2a"
        m3onPrimaryFixed: "#d8d0d0"
        m3onPrimaryFixedVariant: "#6E1616"
        m3secondaryFixed: "#2a2a2a"
        m3secondaryFixedDim: "#222222"
        m3onSecondaryFixed: "#d0c8c8"
        m3onSecondaryFixedVariant: "#444444"
        m3tertiaryFixed: "#252525"
        m3tertiaryFixedDim: "#1e1e1e"
        m3onTertiaryFixed: "#c8c0c0"
        m3onTertiaryFixedVariant: "#3a3a3a"

        // Terminal colors (desaturated for dark bg)
        term0: "#909090"
        term1: "#8a3050"
        term2: "#987050"
        term3: "#886060"
        term4: "#a06868"
        term5: "#884060"
        term6: "#706888"
        term7: "#c8c8c8"
        term8: "#a8a8a8"
        term9: "#a84868"
        term10: "#b88068"
        term11: "#a07070"
        term12: "#c08888"
        term13: "#a85878"
        term14: "#9080a8"
        term15: "#e0e0e0"
    }
    readonly property Transparency transparency: Transparency {}
    readonly property alias wallLuminance: analyser.luminance

    function getLuminance(c: color): real {
        if (c.r == 0 && c.g == 0 && c.b == 0)
            return 0;
        return Math.sqrt(0.299 * (c.r ** 2) + 0.587 * (c.g ** 2) + 0.114 * (c.b ** 2));
    }

    function alterColour(c: color, a: real, layer: int): color {
        const luminance = getLuminance(c);

        const offset = (!light || layer == 1 ? 1 : -layer / 2) * (light ? 0.2 : 0.3) * (1 - transparency.base) * (1 + wallLuminance * (light ? (layer == 1 ? 3 : 1) : 2.5));
        const scale = (luminance + offset) / luminance;
        const r = Math.max(0, Math.min(1, c.r * scale));
        const g = Math.max(0, Math.min(1, c.g * scale));
        const b = Math.max(0, Math.min(1, c.b * scale));

        return Qt.rgba(r, g, b, a);
    }

    function layer(c: color, layer: var): color {
        if (!transparency.enabled)
            return c;

        return layer === 0 ? Qt.alpha(c, transparency.base) : alterColour(c, transparency.layers, layer ?? 1);
    }

    function on(c: color): color {
        if (c.hslLightness < 0.5)
            return Qt.hsla(c.hslHue, c.hslSaturation, 0.9, 1);
        return Qt.hsla(c.hslHue, c.hslSaturation, 0.1, 1);
    }

    function load(data: string, isPreview: bool): void {
        const colours = isPreview ? preview : current;
        const scheme = JSON.parse(data);

        // When dynamic colors are disabled and scheme is dynamic,
        // reset palette back to defaults instead of loading wallpaper colors
        // Choose mode-appropriate defaults
        const defaults = (scheme.mode === "dark") ? _defaultsDark : _defaults;

        if (scheme.name === "dynamic" && !Config.services.dynamicColors) {
            if (!isPreview)
                currentLight = scheme.mode === "light";
            let setCount = 0;
            let failCount = 0;
            // Restore all palette properties from mode-appropriate defaults
            for (const [name, ] of Object.entries(scheme.colours)) {
                const propName = name.startsWith("term") ? name : `m3${name}`;
                const hasC = colours.hasOwnProperty(propName);
                const hasD = defaults.hasOwnProperty(propName);
                if (hasC && hasD) {
                    colours[propName] = defaults[propName];
                    setCount++;
                } else {
                    if (!hasD && propName.startsWith("m3"))
                        failCount++;
                }
            }
            return;
        }

        if (!isPreview) {
            currentLight = scheme.mode === "light";
        } else {
            previewLight = scheme.mode === "light";
        }

        for (const [name, colour] of Object.entries(scheme.colours)) {
            const propName = name.startsWith("term") ? name : `m3${name}`;
            if (colours.hasOwnProperty(propName))
                colours[propName] = `#${colour}`;
        }
    }

    function setMode(mode: string): void {
        Quickshell.execDetached(["/usr/bin/python", "-m", "anachord", "scheme", "set", "--notify", "-m", mode]);
    }

    FileView {
        id: _schemeFile
        path: `${Paths.state}/scheme.json`
        watchChanges: true
        onFileChanged: reload()
        onLoaded: root.load(text(), false)
    }

    Connections {
        target: Config.services
        function onDynamicColorsChanged() {
            // Re-evaluate: reload scheme.json which will apply or skip colors
            _schemeFile.reload();
        }
    }

    ImageAnalyser {
        id: analyser

        source: Wallpapers.current
    }

    component Transparency: QtObject {
        readonly property bool enabled: Appearance.transparency.enabled
        readonly property real base: Appearance.transparency.base - (root.light ? 0.1 : 0)
        readonly property real layers: Appearance.transparency.layers
    }

    component M3TPalette: QtObject {
        readonly property color m3primary_paletteKeyColor: root.layer(root.palette.m3primary_paletteKeyColor)
        readonly property color m3secondary_paletteKeyColor: root.layer(root.palette.m3secondary_paletteKeyColor)
        readonly property color m3tertiary_paletteKeyColor: root.layer(root.palette.m3tertiary_paletteKeyColor)
        readonly property color m3neutral_paletteKeyColor: root.layer(root.palette.m3neutral_paletteKeyColor)
        readonly property color m3neutral_variant_paletteKeyColor: root.layer(root.palette.m3neutral_variant_paletteKeyColor)
        readonly property color m3background: root.layer(root.palette.m3background, 0)
        readonly property color m3onBackground: root.layer(root.palette.m3onBackground)
        readonly property color m3surface: root.layer(root.palette.m3surface, 0)
        readonly property color m3surfaceDim: root.layer(root.palette.m3surfaceDim, 0)
        readonly property color m3surfaceBright: root.layer(root.palette.m3surfaceBright, 0)
        readonly property color m3surfaceContainerLowest: root.layer(root.palette.m3surfaceContainerLowest)
        readonly property color m3surfaceContainerLow: root.layer(root.palette.m3surfaceContainerLow)
        readonly property color m3surfaceContainer: root.layer(root.palette.m3surfaceContainer)
        readonly property color m3surfaceContainerHigh: root.layer(root.palette.m3surfaceContainerHigh)
        readonly property color m3surfaceContainerHighest: root.layer(root.palette.m3surfaceContainerHighest)
        readonly property color m3onSurface: root.layer(root.palette.m3onSurface)
        readonly property color m3surfaceVariant: root.layer(root.palette.m3surfaceVariant, 0)
        readonly property color m3onSurfaceVariant: root.layer(root.palette.m3onSurfaceVariant)
        readonly property color m3inverseSurface: root.layer(root.palette.m3inverseSurface, 0)
        readonly property color m3inverseOnSurface: root.layer(root.palette.m3inverseOnSurface)
        readonly property color m3outline: root.layer(root.palette.m3outline)
        readonly property color m3outlineVariant: root.layer(root.palette.m3outlineVariant)
        readonly property color m3shadow: root.layer(root.palette.m3shadow)
        readonly property color m3scrim: root.layer(root.palette.m3scrim)
        readonly property color m3surfaceTint: root.layer(root.palette.m3surfaceTint)
        readonly property color m3primary: root.layer(root.palette.m3primary)
        readonly property color m3onPrimary: root.layer(root.palette.m3onPrimary)
        readonly property color m3primaryContainer: root.layer(root.palette.m3primaryContainer)
        readonly property color m3onPrimaryContainer: root.layer(root.palette.m3onPrimaryContainer)
        readonly property color m3inversePrimary: root.layer(root.palette.m3inversePrimary)
        readonly property color m3secondary: root.layer(root.palette.m3secondary)
        readonly property color m3onSecondary: root.layer(root.palette.m3onSecondary)
        readonly property color m3secondaryContainer: root.layer(root.palette.m3secondaryContainer)
        readonly property color m3onSecondaryContainer: root.layer(root.palette.m3onSecondaryContainer)
        readonly property color m3tertiary: root.layer(root.palette.m3tertiary)
        readonly property color m3onTertiary: root.layer(root.palette.m3onTertiary)
        readonly property color m3tertiaryContainer: root.layer(root.palette.m3tertiaryContainer)
        readonly property color m3onTertiaryContainer: root.layer(root.palette.m3onTertiaryContainer)
        readonly property color m3error: root.layer(root.palette.m3error)
        readonly property color m3onError: root.layer(root.palette.m3onError)
        readonly property color m3errorContainer: root.layer(root.palette.m3errorContainer)
        readonly property color m3onErrorContainer: root.layer(root.palette.m3onErrorContainer)
        readonly property color m3success: root.layer(root.palette.m3success)
        readonly property color m3onSuccess: root.layer(root.palette.m3onSuccess)
        readonly property color m3successContainer: root.layer(root.palette.m3successContainer)
        readonly property color m3onSuccessContainer: root.layer(root.palette.m3onSuccessContainer)
        readonly property color m3primaryFixed: root.layer(root.palette.m3primaryFixed)
        readonly property color m3primaryFixedDim: root.layer(root.palette.m3primaryFixedDim)
        readonly property color m3onPrimaryFixed: root.layer(root.palette.m3onPrimaryFixed)
        readonly property color m3onPrimaryFixedVariant: root.layer(root.palette.m3onPrimaryFixedVariant)
        readonly property color m3secondaryFixed: root.layer(root.palette.m3secondaryFixed)
        readonly property color m3secondaryFixedDim: root.layer(root.palette.m3secondaryFixedDim)
        readonly property color m3onSecondaryFixed: root.layer(root.palette.m3onSecondaryFixed)
        readonly property color m3onSecondaryFixedVariant: root.layer(root.palette.m3onSecondaryFixedVariant)
        readonly property color m3tertiaryFixed: root.layer(root.palette.m3tertiaryFixed)
        readonly property color m3tertiaryFixedDim: root.layer(root.palette.m3tertiaryFixedDim)
        readonly property color m3onTertiaryFixed: root.layer(root.palette.m3onTertiaryFixed)
        readonly property color m3onTertiaryFixedVariant: root.layer(root.palette.m3onTertiaryFixedVariant)
    }

component M3Palette: QtObject {
        // Neutral Blue-Grey Fallback (overridden by scheme.json)
        property color m3primary_paletteKeyColor: "#AF2828"
        property color m3secondary_paletteKeyColor: "#777777"
        property color m3tertiary_paletteKeyColor: "#7a7776"
        property color m3neutral_paletteKeyColor: "#777777"
        property color m3neutral_variant_paletteKeyColor: "#777777"
        property color m3background: "#fafafa"
        property color m3onBackground: "#1c1c1c"
        property color m3surface: "#fafafa"
        property color m3surfaceDim: "#dadada"
        property color m3surfaceBright: "#fafafa"
        property color m3surfaceContainerLowest: "#ffffff"
        property color m3surfaceContainerLow: "#f4f4f4"
        property color m3surfaceContainer: "#eeeeee"
        property color m3surfaceContainerHigh: "#e8e8e8"
        property color m3surfaceContainerHighest: "#e3e3e3"
        property color m3onSurface: "#1c1c1c"
        property color m3surfaceVariant: "#e3e3e3"
        property color m3onSurfaceVariant: "#474747"
        property color m3inverseSurface: "#303030"
        property color m3inverseOnSurface: "#f1f1f1"
        property color m3outline: "#747474"
        property color m3outlineVariant: "#c7c7c7"
        property color m3shadow: "#000000"
        property color m3scrim: "#000000"
        property color m3surfaceTint: "#AF2828"
        property color m3primary: "#AF2828"
        property color m3onPrimary: "#FFFFFF"
        property color m3primaryContainer: "#FADED8"
        property color m3onPrimaryContainer: "#731515"
        property color m3inversePrimary: "#E89E9E"
        property color m3secondary: "#C85050"
        property color m3onSecondary: "#ffffff"
        property color m3secondaryContainer: "#F5E8E7"
        property color m3onSecondaryContainer: "#8C2020"
        property color m3tertiary: "#D47070"
        property color m3onTertiary: "#ffffff"
        property color m3tertiaryContainer: "#F5DEDE"
        property color m3onTertiaryContainer: "#6E2020"
        property color m3error: "#af2828"
        property color m3onError: "#ffffff"
        property color m3errorContainer: "#FADED8"
        property color m3onErrorContainer: "#891818"
        property color m3success: "#4F6354"
        property color m3onSuccess: "#FFFFFF"
        property color m3successContainer: "#D1E8D5"
        property color m3onSuccessContainer: "#0C1F13"
        property color m3primaryFixed: "#FADED8"
        property color m3primaryFixedDim: "#E89E9E"
        property color m3onPrimaryFixed: "#4A100D"
        property color m3onPrimaryFixedVariant: "#8C2020"
        property color m3secondaryFixed: "#e2e2e2"
        property color m3secondaryFixedDim: "#c7c7c7"
        property color m3onSecondaryFixed: "#1c1c1c"
        property color m3onSecondaryFixedVariant: "#464646"
        property color m3tertiaryFixed: "#e6e2e1"
        property color m3tertiaryFixedDim: "#cac5c5"
        property color m3onTertiaryFixed: "#1d1b1b"
        property color m3onTertiaryFixedVariant: "#494646"
        property color term0: "#9b9b9b"
        property color term1: "#a6395d"
        property color term2: "#b86c57"
        property color term3: "#9c5e66"
        property color term4: "#b97774"
        property color term5: "#a54d6e"
        property color term6: "#8a79a0"
        property color term7: "#222222"
        property color term8: "#0f0f0f"
        property color term9: "#c35174"
        property color term10: "#dd8b75"
        property color term11: "#bb7881"
        property color term12: "#e19996"
        property color term13: "#c46689"
        property color term14: "#ab99c1"
        property color term15: "#282828"
    }
}
