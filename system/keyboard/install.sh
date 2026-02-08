#!/usr/bin/env sh
set -e

# ==========================
# Paths & filenames
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Module paths
DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/system/keyboard"
SCRIPT_NAME="keyboard.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
XINITRC="$HOME/.xinitrc"

# ==========================
# Create config directory
# ==========================

mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink keyboard script
# ==========================
# Single source of truth lives in dotfiles repo

ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# ==========================
# Ensure ~/.xinitrc exists
# ==========================

if [ ! -f "$XINITRC" ]; then
  touch "$XINITRC"
  chmod +x "$XINITRC"
fi

# ==========================
# Remove old keyboard entries (idempotent)
# ==========================

sed -i '/keyboard\.sh/d' "$XINITRC"
sed -i '/# Keyboard setup/d' "$XINITRC"

# ==========================
# Insert keyboard hook BEFORE exec dwm
# ==========================

if grep -q "^exec dwm" "$XINITRC"; then
  sed -i "/^exec dwm/i\\
# Keyboard setup\n\"$TARGET_SCRIPT\"\n" "$XINITRC"
else
  # If exec dwm is missing, append safely
  {
    echo ""
    echo "# Keyboard setup"
    echo "\"$TARGET_SCRIPT\""
  } >> "$XINITRC"
fi

echo "Keyboard configuration installed."
