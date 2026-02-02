#!/bin/sh

set -e

# Paths
DOTFILES_DIR="$HOME/.dotfiles/system/display"
CONFIG_DIR="$HOME/.config/system/display"
SCRIPT_NAME="monitor-setup.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
TARGET_WALLPAPER="$CONFIG_DIR/wallpaper"

XINITRC="$HOME/.xinitrc"

# --------------------------
# Create config directory
# --------------------------
mkdir -p "$CONFIG_DIR"

# --------------------------
# Symlink display script
# --------------------------
ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# --------------------------
# Symlink wallpaper directory
# --------------------------
ln -sfn "$DOTFILES_DIR/wallpaper" "$TARGET_WALLPAPER"

# --------------------------
# Ensure .xinitrc exists
# --------------------------
if [ ! -f "$XINITRC" ]; then
  touch "$XINITRC"
  chmod +x "$XINITRC"
fi

# --------------------------
# Remove any existing display hook
# --------------------------
sed -i '/monitor-setup\.sh/d' "$XINITRC"
sed -i '/# Display setup/d' "$XINITRC"

# --------------------------
# Insert display hook before exec dwm
# --------------------------
if grep -q "^exec dwm" "$XINITRC"; then
  sed -i "/^exec dwm/i\\
# Display setup\n\"$TARGET_SCRIPT\"\n" "$XINITRC"
else
  # If exec dwm not found, append safely
  {
    echo ""
    echo "# Display setup"
    echo "\"$TARGET_SCRIPT\""
  } >> "$XINITRC"
fi
