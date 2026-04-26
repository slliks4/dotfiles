#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="screenshot"

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

ensure_pkg maim
ensure_pkg slop
ensure_pkg xclip
ensure_pkg libnotify
ensure_pkg python

# --------------------------
# Create bin directory
# --------------------------
mkdir -p "$BIN_DIR"

# --------------------------
# Symlink script
# --------------------------
chmod +x "$SCRIPT_DIR/$SCRIPT_NAME"
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# --------------------------
# Done
# --------------------------
echo "Screenshot utility installed"
echo "-> $TARGET_SCRIPT"
