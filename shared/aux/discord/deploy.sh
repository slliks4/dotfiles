#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

INSTALL_ROOT="$HOME/opt"
INSTALL_DIR="$INSTALL_ROOT/discord"

LOCAL_BIN="$HOME/.local/bin"
BIN_LINK="$LOCAL_BIN/discord"
DEPLOY_LINK="$LOCAL_BIN/deploy-discord"

DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_LINK="$DESKTOP_DIR/discord.desktop"
DESKTOP_SRC="$SCRIPT_DIR/discord.desktop"

DISCORD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg curl
ensure_pkg tar

# ==========================
# Temp directory
# ==========================
TMP_DIR="$(mktemp -d)"

cleanup() {
    [ -d "$TMP_DIR" ] && rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Discord deploy (tar.gz)"

# ==========================
# Download
# ==========================
echo "Downloading Discord"
curl -L "$DISCORD_URL" -o "$TMP_DIR/discord.tar.gz"

# ==========================
# Install
# ==========================
echo "Installing to $INSTALL_DIR"
mkdir -p "$INSTALL_ROOT"
rm -rf "$INSTALL_DIR"

tar -xzf "$TMP_DIR/discord.tar.gz" -C "$INSTALL_ROOT"
mv "$INSTALL_ROOT/Discord" "$INSTALL_DIR"

# ==========================
# Bin symlinks
# ==========================
mkdir -p "$LOCAL_BIN"

ln -sf "$INSTALL_DIR/Discord" "$BIN_LINK"
ln -sf "$SCRIPT_DIR/deploy.sh" "$DEPLOY_LINK"

echo "Binary linked -> $BIN_LINK"
echo "Deploy linked -> $DEPLOY_LINK"

# ==========================
# Desktop entry
# ==========================
mkdir -p "$DESKTOP_DIR"

if [ ! -f "$DESKTOP_SRC" ]; then
    echo "Missing desktop entry: $DESKTOP_SRC"
    exit 1
fi

ln -sf "$DESKTOP_SRC" "$DESKTOP_LINK"

echo "Desktop linked -> $DESKTOP_LINK"

# ==========================
# Done
# ==========================
echo "Discord installed"
echo "Install dir: $INSTALL_DIR"
