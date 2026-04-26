#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="dj"

SRC="$SCRIPT_DIR/$SCRIPT_NAME"
TARGET="$BIN_DIR/$SCRIPT_NAME"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg python

# ==========================
# Install
# ==========================
mkdir -p "$BIN_DIR"

if [ ! -f "$SRC" ]; then
    echo "Missing script: $SRC"
    exit 1
fi

chmod +x "$SRC"
ln -sf "$SRC" "$TARGET"

echo "dj installed -> $TARGET"
echo "Run: dj start <ProjectName>"
