#!/usr/bin/env sh
set -e

# ==========================
# Helpers
# ==========================

check_dep() {
  command -v "$1" >/dev/null 2>&1
}

# ==========================
# Paths & filenames
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

DOTFILES_DIR="$SCRIPT_DIR"
BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="battery-mode"

TARGET_SCRIPT="$BIN_DIR/$SCRIPT_NAME"

# ==========================
# Dependencies
# ==========================

install_pkgs=""

check_dep powerprofilesctl || install_pkgs="$install_pkgs power-profiles-daemon"
check_dep light            || install_pkgs="$install_pkgs light"
check_dep notify-send      || install_pkgs="$install_pkgs libnotify"
check_dep python           || install_pkgs="$install_pkgs python"
check_dep python-gobject   || install_pkgs="$install_pkgs python-gobject"

if [ -n "$install_pkgs" ]; then
  echo "📦 Installing missing dependencies:$install_pkgs"
  sudo pacman -S --needed $install_pkgs
fi

# ==========================
# Enable power-profiles-daemon
# ==========================

sudo systemctl enable power-profiles-daemon --now

# ==========================
# Create bin directory
# ==========================

mkdir -p "$BIN_DIR"

# ==========================
# Symlink battery-mode script
# ==========================

ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$DOTFILES_DIR/$SCRIPT_NAME"

echo "✓ battery-mode installed and linked to $TARGET_SCRIPT"
