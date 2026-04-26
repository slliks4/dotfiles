#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
VIDEO_DIR="$HOME/Videos/Recordings"

SCRIPT_NAME="xrecord"
TARGET_SCRIPT="$BIN_DIR/$SCRIPT_NAME"

# --------------------------
# Dependencies
# --------------------------
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg ffmpeg
ensure_pkg slop
ensure_pkg libnotify
ensure_pkg pipewire-pulse   # provides pactl
ensure_pkg wireplumber

# --------------------------
# Create directories
# --------------------------
mkdir -p "$BIN_DIR"
mkdir -p "$VIDEO_DIR"

# --------------------------
# Symlink script
# --------------------------
chmod +x "$SCRIPT_DIR/$SCRIPT_NAME"
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# --------------------------
# Done
# --------------------------
echo "Screen recording utility installed"
echo "-> $TARGET_SCRIPT"
echo "Recordings directory: $VIDEO_DIR"
