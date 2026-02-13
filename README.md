# Anachord

A white & red themed desktop shell for Wayland, built with [Quickshell](https://quickshell.outfoxxed.me/).

Forked from [Vermilion (caelestia-dots/shell)](https://github.com/caelestia-dots/shell), renamed and redesigned with a unified red + white accent language.

> **Ana-** (emergence) + **chord** (string) — the harmonic thread that emerges.

## Structure

```
anachord/
├── shell/       # QML desktop shell UI
├── cli/         # Python CLI companion tool
├── PKGBUILD     # Arch Linux packaging
└── LICENSE       # GPL-3.0
```

## Installation (Arch Linux)

### From Release

Download `anachord-shell-1.0.0-1-x86_64.pkg.tar.zst` from [Releases](https://github.com/yumiaoyi-o/anachord/releases), then:

```bash
sudo pacman -U anachord-shell-1.0.0-1-x86_64.pkg.tar.zst
```

### From Source

```bash
git clone https://github.com/yumiaoyi-o/anachord.git
cd anachord
makepkg -si
```

### Shell Setup

Copy the shell files to Quickshell's config directory:

```bash
cp -r shell/ ~/.config/quickshell/Anachord/
```

## Dependencies

- [quickshell-git](https://aur.archlinux.org/packages/quickshell-git) — QML Wayland shell framework
- Python 3.14+
- ddcutil, brightnessctl, networkmanager, lm_sensors, fish, libpipewire, libcava, aubio
- Qt 6 (qt6-base, qt6-declarative)
- Fonts: ttf-material-symbols-variable, ttf-rubik-vf, ttf-cascadia-code-nerd

## Design

- Unified accent: vivid red (`#C02828`) + white (`#FFFFFF`)
- Dark mode primary palette with tree-structured component color tokens
- All highlights, toggles, active states use the same red/white pair

## License

GPL-3.0-only. See [LICENSE](LICENSE).
