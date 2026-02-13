# Maintainer: yumiaoyi-o <yumiaoyio@outlook.com>
pkgname=anachord-shell
pkgver=1.0.0
pkgrel=1
pkgdesc='Anachord - A white & red themed Quickshell desktop shell'
arch=('x86_64')
url='https://github.com/yumiaoyi-o/anachord'
license=('GPL-3.0-only')
depends=(
  'quickshell-git'
  'ddcutil'
  'brightnessctl'
  'app2unit'
  'libcava'
  'networkmanager'
  'lm_sensors'
  'fish'
  'aubio'
  'libpipewire'
  'glibc'
  'gcc-libs'
  'ttf-material-symbols-variable'
  'power-profiles-daemon'
  'ttf-rubik-vf'
  'ttf-cascadia-code-nerd'
  'libqalculate'
  'bash'
  'qt6-base'
  'qt6-declarative'
  'python'
)
provides=('anachord-shell' 'anachord-cli')
conflicts=('vermilion-shell' 'vermilion-cli' 'caelestia-shell' 'caelestia-cli')

package() {
  cd "$srcdir/.."

  # Install CLI Python package
  install -dm755 "$pkgdir/usr/lib/python3.14/site-packages"
  cp -a cli/ "$pkgdir/usr/lib/python3.14/site-packages/anachord"

  # Install CLI entry point
  install -Dm755 /dev/stdin "$pkgdir/usr/bin/anachord" <<'EOF'
#!/bin/bash
exec /usr/bin/python -m anachord "$@"
EOF

  # Install shell config (system default)
  install -dm755 "$pkgdir/etc/xdg/quickshell"
  cp -a shell/ "$pkgdir/etc/xdg/quickshell/Anachord"
}
