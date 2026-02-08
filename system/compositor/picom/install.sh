#!/usr/bin/env sh
set -e

# ==========================
# Helpers
# ==========================

check_dep() {
  command -v "$1" >/dev/null 2>&1
}

# ==========================
# Paths & filenames
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/picom"
CONFIG_NAME="picom.conf"

TARGET_CONFIG="$CONFIG_DIR/$CONFIG_NAME"
XINITRC="$HOME/.xinitrc"

# ==========================
# Dependencies
# ==========================

install_pkgs=""

check_dep picom || install_pkgs="$install_pkgs picom"

if [ -n "$install_pkgs" ]; then
  echo "📦 Installing missing dependencies:$install_pkgs"
  sudo pacman -S --needed $install_pkgs
fi

# ==========================
# Create config directory
# ==========================

mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink picom config
# ==========================

ln -sf "$DOTFILES_DIR/$CONFIG_NAME" "$TARGET_CONFIG"

# ==========================
# Ensure ~/.xinitrc exists
# ==========================

if [ ! -f "$XINITRC" ]; then
  touch "$XINITRC"
  chmod +x "$XINITRC"
fi

# ==========================
# Remove old picom entries
# ==========================

sed -i '/picom/d' "$XINITRC"
sed -i '/# Compositor/d' "$XINITRC"

# ==========================
# Insert picom BEFORE exec dwm
# ==========================

if grep -q "^exec dwm" "$XINITRC"; then
  sed -i "/^exec dwm/i\\
# Compositor\npicom &\n" "$XINITRC"
else
  {
    echo ""
    echo "# Compositor"
    echo "picom &"
  } >> "$XINITRC"
fi

echo "✓ Picom installed and configured."
