#!/usr/bin/env sh
set -e

# --------------------------
# Dependency check
# --------------------------
if ! command -v alacritty >/dev/null 2>&1; then
  echo "❌ alacritty not found"
  echo "➡️  Install it first (e.g. pacman -S alacritty)"
  exit 1
fi

# --------------------------
# Paths
# --------------------------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/alacritty"
SRC="$SCRIPT_DIR/alacritty.toml"
TARGET="$CONFIG_DIR/alacritty.toml"

# --------------------------
# Install
# --------------------------
mkdir -p "$CONFIG_DIR"

rm -f "$TARGET"
ln -s "$SRC" "$TARGET"

echo "✔ Alacritty config installed"
