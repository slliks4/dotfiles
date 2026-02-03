#!/usr/bin/env bash
set -Eeuo pipefail

# Discord (tar.gz) deploy script.
#
# Why tar.gz:
# - Discord upstream updates frequently
# - distro packages can lag or mismatch
# - this keeps Discord vendor-sourced and predictable
#
# What this does:
# 1) Downloads latest Discord tar.gz
# 2) Installs to:   ~/opt/discord
# 3) Symlinks bin:  ~/.local/bin/discord  -> ~/opt/discord/Discord
# 4) Symlinks menu: ~/.local/share/applications/discord.desktop -> dotfiles desktop entry
#
# Run:
#   ~/.dotfiles/aux/discord/deploy.sh

DISCORD_URL="https://discord.com/api/download?platform=linux&format=tar.gz"

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
APP_DIR="$DOTFILES_DIR/aux/discord"

INSTALL_ROOT="$HOME/opt"
INSTALL_DIR="$INSTALL_ROOT/discord"

LOCAL_BIN="$HOME/.local/bin"
BIN_LINK="$LOCAL_BIN/discord"
DEPLOY_BIN_LINK="$LOCAL_BIN/deploy-discord"

DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_LINK="$DESKTOP_DIR/discord.desktop"
DESKTOP_SRC="$APP_DIR/discord.desktop"

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "❌ Missing dependency: $1"
    exit 1
  fi
}

cleanup() {
  [[ -n "${TMP_DIR:-}" && -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "==> Discord deploy (tar.gz)"

# --- deps ---
need_cmd curl
need_cmd tar

# --- temp download dir ---
TMP_DIR="$(mktemp -d)"

echo "-> Downloading Discord…"
curl -L "$DISCORD_URL" -o "$TMP_DIR/discord.tar.gz"

echo "-> Installing to $INSTALL_DIR"
mkdir -p "$INSTALL_ROOT"
rm -rf "$INSTALL_DIR"

# Tarball extracts a top-level "Discord/" directory into INSTALL_ROOT
tar -xzf "$TMP_DIR/discord.tar.gz" -C "$INSTALL_ROOT"
mv "$INSTALL_ROOT/Discord" "$INSTALL_DIR"

# --- symlink binary into ~/.local/bin ---
echo "-> Linking binary: $BIN_LINK"
mkdir -p "$LOCAL_BIN"
ln -sf "$INSTALL_DIR/Discord" "$BIN_LINK"

# --- symlink deploy into ~/.local/bin/deploy-discord ---
echo "-> Linking binary: $DEPLOY_BIN_LINK"
mkdir -p "$LOCAL_BIN"
ln -sf "$APP_DIR/deploy.sh" "$DEPLOY_BIN_LINK"

# --- symlink desktop entry ---
echo "-> Linking desktop entry: $DESKTOP_LINK"
mkdir -p "$DESKTOP_DIR"

if [[ ! -f "$DESKTOP_SRC" ]]; then
  echo "❌ Missing desktop entry in dotfiles: $DESKTOP_SRC"
  echo "Create it (see discord.desktop in this folder) and re-run."
  exit 1
fi

ln -sf "$DESKTOP_SRC" "$DESKTOP_LINK"

echo "✅ Discord ready."
echo "   Binary:  $BIN_LINK"
echo "   Install: $INSTALL_DIR"
echo "   Desktop: $DESKTOP_LINK"
