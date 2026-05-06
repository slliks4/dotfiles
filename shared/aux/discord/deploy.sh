#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

INSTALL_ROOT="$HOME/opt"
INSTALL_DIR="$INSTALL_ROOT/discord"

LOCAL_BIN="$HOME/.local/bin"
BIN_LINK="$LOCAL_BIN/discord"
DEPLOY_LINK="$LOCAL_BIN/deploy-discord"

DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_LINK="$DESKTOP_DIR/discord.desktop"

CUSTOM_DESKTOP="$SCRIPT_DIR/discord.desktop"
INSTALLED_DESKTOP="$INSTALL_DIR/discord.desktop"

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
echo "Downloading Discord..."

curl -L "$DISCORD_URL" \
    -o "$TMP_DIR/discord.tar.gz"

# ==========================
# Install
# ==========================
echo "Installing to $INSTALL_DIR..."

mkdir -p "$INSTALL_ROOT"

rm -rf "$INSTALL_DIR"

tar -xzf "$TMP_DIR/discord.tar.gz" \
    -C "$INSTALL_ROOT"

mv "$INSTALL_ROOT/Discord" "$INSTALL_DIR"

# ==========================
# Desktop override
# ==========================
if [ -f "$CUSTOM_DESKTOP" ]; then
    echo "Overriding discord.desktop"

    cp "$CUSTOM_DESKTOP" "$INSTALLED_DESKTOP"
else
    echo "Custom desktop entry not found"
    exit 1
fi

# ==========================
# Bin symlinks
# ==========================
mkdir -p "$LOCAL_BIN"

DISCORD_BIN="$(find "$INSTALL_DIR" \
    -maxdepth 1 \
    -type f \
    -executable \
    -iname "discord")"

if [ -z "$DISCORD_BIN" ]; then
    echo "Discord executable not found"
    exit 1
fi

ln -sf "$DISCORD_BIN" "$BIN_LINK"
ln -sf "$SCRIPT_DIR/deploy.sh" "$DEPLOY_LINK"

# ==========================
# Desktop symlink
# ==========================
mkdir -p "$DESKTOP_DIR"

ln -sf "$INSTALLED_DESKTOP" "$DESKTOP_LINK"

# ==========================
# Done
# ==========================
echo "Discord installed successfully"
echo "Binary  -> $BIN_LINK"
echo "Desktop -> $DESKTOP_LINK"
echo "Install -> $INSTALL_DIR"
