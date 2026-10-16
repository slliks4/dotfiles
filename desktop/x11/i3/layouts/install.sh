#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
SOURCE="$SCRIPT_DIR/dev-layout"
TARGET="$BIN_DIR/dev-layout"
SECOND_SOURCE="$SCRIPT_DIR/toggle-i3-screen-layout"
SECOND_TARGET="$BIN_DIR/toggle-i3-screen-layout"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg jq

# ==========================
# Ensure bin dir exists
# ==========================
mkdir -p "$BIN_DIR"

# ==========================
# Validate source
# ==========================
if [ ! -f "$SOURCE" ]; then
    echo "Missing dev-layout script: $SOURCE"
    exit 1
fi


# ==========================
# Install (symlink)
# ==========================
chmod +x "$SOURCE"
ln -sf "$SOURCE" "$TARGET"
echo "dev-layout installed -> $TARGET"

# ==========================
# Validate second source
# ==========================
if [ ! -f "$SECOND_SOURCE" ]; then
    echo "Missing toggle script skipping: $SECOND_SOURCE"
    else
        chmod +x "$SECOND_SOURCE"
        ln -sf "$SECOND_SOURCE" "$SECOND_TARGET"
        echo "toggle layout script installed -> $SECOND_TARGET"
fi

