#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
GUARD_SCRIPT="browser-guard.sh"
TARGET_GUARD="$BIN_DIR/browser-guard"

# ==========================
# Ensure paru exists
# ==========================

if ! command -v paru >/dev/null 2>&1; then
    echo "paru not found."
    echo "Install paru first before running this script."
    exit 1
fi

echo "Ensuring required packages are installed..."

# ==========================
# Install all required packages
# ==========================

paru -S --needed --noconfirm \
    brave-bin \
    firefox-developer-edition \
    qutebrowser

# ==========================
# Ensure bin directory exists
# ==========================

mkdir -p "$BIN_DIR"

# ==========================
# Symlink browser-guard
# ==========================

chmod +x "$SCRIPT_DIR/$GUARD_SCRIPT"
ln -sf "$SCRIPT_DIR/$GUARD_SCRIPT" "$TARGET_GUARD"

echo "Browsers and portal ensured."
echo "browser-guard installed at:"
echo "→ $TARGET_GUARD"
