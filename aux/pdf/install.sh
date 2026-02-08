#!/usr/bin/env sh
set -e

# ==========================
# Zathura PDF Viewer Setup
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Paths
DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/zathura"
CONFIG_TARGET="$CONFIG_DIR/zathurarc"
CONFIG_SRC="$DOTFILES_DIR/zathurarc"

ZSHRC="$HOME/.zshrc"
ALIAS_LINE='alias pdf="zathura"'

# --------------------------
# Dependencies
# --------------------------

if ! command -v zathura >/dev/null 2>&1; then
  echo "Installing zathura"
  sudo pacman -S --needed --noconfirm zathura zathura-pdf-mupdf
fi

# --------------------------
# Link config
# --------------------------

mkdir -p "$CONFIG_DIR"

ln -sf "$CONFIG_SRC" "$CONFIG_TARGET"
echo "✔ Linked zathura config"

# --------------------------
# Optional shell alias
# --------------------------

if [ -f "$ZSHRC" ] && ! grep -qxF "$ALIAS_LINE" "$ZSHRC"; then
  {
    echo ""
    echo "# PDF viewer"
    echo "$ALIAS_LINE"
  } >> "$ZSHRC"
  echo "✔ Added pdf alias to .zshrc"
else
  echo "✔ pdf alias already present or .zshrc missing"
fi

# --------------------------
# Done
# --------------------------

echo "Zathura setup complete"
