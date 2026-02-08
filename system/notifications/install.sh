#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Module paths
DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/system/notifications"
SCRIPT_NAME="dunst.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
XINITRC="$HOME/.xinitrc"

DUNST_CONFIG_DIR="$HOME/.config/dunst"
DUNST_RC_TARGET="$DUNST_CONFIG_DIR/dunstrc"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg dunst
ensure_pkg libnotify

# ==========================
# Setup directories
# ==========================
mkdir -p "$CONFIG_DIR"
mkdir -p "$DUNST_CONFIG_DIR"


# ==========================
# Symlink script
# ==========================
# Ensure source script is executable
chmod +x "$DOTFILES_DIR/$SCRIPT_NAME"
chmod +x "$DOTFILES_DIR/dunstrc"

# Create / update symlink
ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
ln -sf "$DOTFILES_DIR/dunstrc" "$DUNST_RC_TARGET"

# ==========================
# Ensure .xinitrc exists
# ==========================
if [ ! -f "$XINITRC" ]; then
    touch "$XINITRC"
    chmod +x "$XINITRC"
fi

# ==========================
# Remove old entries
# ==========================
sed -i '/dunst\.sh/d' "$XINITRC"
sed -i '/# Notifications/d' "$XINITRC"

# ==========================
# Insert before exec dwm
# ==========================
if grep -q "^exec dwm" "$XINITRC"; then
    sed -i "/^exec dwm/i\\
# Notifications\n\"$TARGET_SCRIPT\"\n" "$XINITRC"
else
    {
        echo ""
        echo "# Notifications"
        echo "\"$TARGET_SCRIPT\""
    } >> "$XINITRC"
fi

echo "Dunst notifications installed."
