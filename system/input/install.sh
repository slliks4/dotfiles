#!/bin/sh

set -e

# ==========================
# Paths & filenames
# ==========================
DOTFILES_DIR="$HOME/.dotfiles/system/input"
CONFIG_DIR="$HOME/.config/system/input"
SCRIPT_NAME="trackpad.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
XINITRC="$HOME/.xinitrc"

# ==========================
# Dependency check
# ==========================
# xinput is required for libinput configuration

if ! command -v xinput >/dev/null 2>&1; then
  echo "📦 Installing missing dependency: xorg-xinput"
  sudo pacman -S --needed xorg-xinput
fi

# ==========================
# Create config directory
# ==========================
mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink trackpad script
# ==========================
# Single source of truth lives in dotfiles repo

ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

# ==========================
# Ensure ~/.xinitrc exists
# ==========================
if [ ! -f "$XINITRC" ]; then
  touch "$XINITRC"
  chmod +x "$XINITRC"
fi

# ==========================
# Remove old trackpad entries (idempotent)
# ==========================
sed -i '/trackpad\.sh/d' "$XINITRC"
sed -i '/# Trackpad setup/d' "$XINITRC"

# ==========================
# Insert trackpad hook BEFORE exec dwm
# ==========================
if grep -q "^exec dwm" "$XINITRC"; then
  sed -i "/^exec dwm/i\\
# Trackpad setup\n\"$TARGET_SCRIPT\"\n" "$XINITRC"
else
  # If exec dwm is missing, append safely
  {
    echo ""
    echo "# Trackpad setup"
    echo "\"$TARGET_SCRIPT\""
  } >> "$XINITRC"
fi

echo "Trackpad configuration installed."
