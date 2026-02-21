#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

BIN_DIR="$HOME/.local/bin"
VIDEO_DIR="$HOME/Videos/Recordings"

SCRIPT_NAME="xrecord"
TARGET_SCRIPT="$BIN_DIR/$SCRIPT_NAME"

# --------------------------
# Dependency checks
# (binary → package)
# --------------------------

check_dep() {
  command -v "$1" >/dev/null 2>&1
}

install_pkgs=""

check_dep ffmpeg      || install_pkgs="$install_pkgs ffmpeg"
check_dep slop        || install_pkgs="$install_pkgs slop"
check_dep notify-send || install_pkgs="$install_pkgs libnotify"

# PulseAudio only needed if using toggle-mic
check_dep pactl       || install_pkgs="$install_pkgs pulseaudio"

if [ -n "$install_pkgs" ]; then
  echo "Installing missing dependencies:$install_pkgs"
  sudo pacman -S --needed $install_pkgs
fi

# --------------------------
# Create directories
# --------------------------

mkdir -p "$BIN_DIR"
mkdir -p "$VIDEO_DIR"

# --------------------------
# Symlink script
# --------------------------

chmod +x "$DOTFILES_DIR/$SCRIPT_NAME"
ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# --------------------------
# Done
# --------------------------

echo "Screen recording utility installed"
echo "→ $TARGET_SCRIPT"
echo "Recordings directory: $VIDEO_DIR"
