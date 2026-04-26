#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="lock-suspend.sh"
TARGET_SCRIPT="$BIN_DIR/lock"

# --------------------------
# Dependency check
# --------------------------

ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg slock

# --------------------------
# Ensure bin directory exists
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

echo "Lock script installed:"
echo "→ $TARGET_SCRIPT"
