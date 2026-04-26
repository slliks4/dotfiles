#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_SOURCE="$SCRIPT_DIR/config"
TARGET_DIR="$HOME/.config/i3status"
TARGET_CONFIG="$TARGET_DIR/config"

ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg i3status

if [ ! -f "$CONFIG_SOURCE" ]; then
    echo "Missing i3status config:"
    echo "$CONFIG_SOURCE"
    exit 1
fi

mkdir -p "$TARGET_DIR"

if [ -e "$TARGET_CONFIG" ] && [ ! -L "$TARGET_CONFIG" ]; then
    TS=$(date +"%Y%m%d-%H%M%S")
    mv "$TARGET_CONFIG" "${TARGET_CONFIG}.bak-$TS"
    echo "Backed up existing config -> ${TARGET_CONFIG}.bak-$TS"
fi

if [ -L "$TARGET_CONFIG" ]; then
    rm "$TARGET_CONFIG"
fi

ln -s "$CONFIG_SOURCE" "$TARGET_CONFIG"
echo "Symlinked i3status config -> $TARGET_CONFIG"

echo
echo "i3status installed"
