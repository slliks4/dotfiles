#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Module paths
DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/system/status"
SCRIPT_NAME="status.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
XINITRC="$HOME/.xinitrc"

# --------------------------
# Create config directory
# --------------------------
mkdir -p "$CONFIG_DIR"

# --------------------------
# Symlink status script
# --------------------------
ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

# --------------------------
# Ensure .xinitrc exists
# --------------------------
if [ ! -f "$XINITRC" ]; then
    touch "$XINITRC"
    chmod +x "$XINITRC"
fi

# --------------------------
# Remove old entries (idempotent)
# --------------------------
sed -i '/status\.sh/d' "$XINITRC"
sed -i '/# Status bar/d' "$XINITRC"

# --------------------------
# Insert before exec dwm
# --------------------------
if grep -q "^exec dwm" "$XINITRC"; then
    sed -i "/^exec dwm/i\\
# Status bar\n\"$TARGET_SCRIPT\" &\n" "$XINITRC"
else
    {
        echo ""
        echo "# Status bar"
        echo "\"$TARGET_SCRIPT\" &"
    } >> "$XINITRC"
fi

echo "Status bar installed."
