#!/usr/bin/env bash

set -e

# Resolve script directory (absolute path)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg alacritty

CONFIG_DIR="$HOME/.config/alacritty"
SRC="$SCRIPT_DIR/alacritty.toml"
TARGET="$CONFIG_DIR/alacritty.toml"

mkdir -p "$CONFIG_DIR"

rm -f "$TARGET"
ln -sf "$SRC" "$TARGET"

echo "Alacritty config installed"
