#!/usr/bin/env bash
set -e

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# Core X11
ensure_pkg xorg-server
ensure_pkg xorg-xinit

# Minimal utilities (safe defaults)
ensure_pkg xorg-xrandr
ensure_pkg xorg-xset

# ==========================
# Runtime directories
# ==========================
X11_CONFIG_DIR="$HOME/.config/x11"
CONF_D="$X11_CONFIG_DIR/conf.d"

mkdir -p "$CONF_D"

echo "Created X11 runtime directory:"
echo "  $CONF_D"

echo
echo "X11 base installed"
echo "Fonts are handled separately (shared/system/fonts)"
echo "Next: install a window manager (i3 or dwm)"
