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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

DOTFILES_DIR="$SCRIPT_DIR"
BIN_DIR="$HOME/.local/bin"

SCRIPT_MODE="battery-mode"
SCRIPT_NOTIFY="battery-notify"

TARGET_MODE="$BIN_DIR/$SCRIPT_MODE"
TARGET_NOTIFY="$BIN_DIR/$SCRIPT_NOTIFY"

XINITRC="$HOME/.xinitrc"

# ==========================
# Dependencies
# ==========================

install_pkgs=""

check_dep powerprofilesctl || install_pkgs="$install_pkgs power-profiles-daemon"
check_dep light            || install_pkgs="$install_pkgs light"
check_dep notify-send      || install_pkgs="$install_pkgs libnotify"
check_dep python           || install_pkgs="$install_pkgs python"
check_dep python-gobject   || install_pkgs="$install_pkgs python-gobject"

if [ -n "$install_pkgs" ]; then
  echo "Installing missing dependencies:$install_pkgs"
  sudo pacman -S --needed $install_pkgs
fi

# ==========================
# Enable power-profiles-daemon
# ==========================

sudo systemctl enable power-profiles-daemon --now

# ==========================
# Create bin directory
# ==========================

mkdir -p "$BIN_DIR"

# ==========================
# Symlink scripts
# ==========================

ln -sf "$DOTFILES_DIR/$SCRIPT_MODE" "$TARGET_MODE"
chmod +x "$TARGET_MODE"

ln -sf "$DOTFILES_DIR/$SCRIPT_NOTIFY" "$TARGET_NOTIFY"
chmod +x "$TARGET_NOTIFY"

echo "battery-mode installed at $TARGET_MODE"
echo "battery-notify installed at $TARGET_NOTIFY"

# ==========================
# Ensure .xinitrc exists
# ==========================

[ -f "$XINITRC" ] || touch "$XINITRC"

# ==========================
# Remove old entries (idempotent)
# ==========================

sed -i '/battery-notify/d' "$XINITRC"
sed -i '/# Battery notify/d' "$XINITRC"

# ==========================
# Insert before exec dwm
# ==========================

if grep -q "^exec dwm" "$XINITRC"; then
    sed -i "/^exec dwm/i\\
# Battery notify\n\"$TARGET_NOTIFY\" &\n" "$XINITRC"
else
    {
        echo ""
        echo "# Battery notify"
        echo "\"$TARGET_NOTIFY\" &"
    } >> "$XINITRC"
fi

echo "battery-notify added to .xinitrc"
