#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==========================
# Paths
# ==========================
CONFIG_DIR="$HOME/.config/system/display"
SCRIPT_NAME="monitor-setup.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
TARGET_WALLPAPER="$CONFIG_DIR/wallpaper"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
DISPLAY_HOOK="$X11_CONF_DIR/display.sh"

BINPATH="$HOME/.local/bin"
RESYNC="$BINPATH/resync-session"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg feh

# ==========================
# Create config directory
# ==========================
mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink display script
# ==========================
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# ==========================
# Symlink wallpaper directory
# ==========================
ln -sfn "$SCRIPT_DIR/wallpaper" "$TARGET_WALLPAPER"

# ==========================
# Setup X11 conf.d hook
# ==========================
mkdir -p "$X11_CONF_DIR"

cat > "$DISPLAY_HOOK" << EOF
#!/usr/bin/env sh
"$TARGET_SCRIPT"
EOF

chmod +x "$DISPLAY_HOOK"

echo "Display hook installed -> $DISPLAY_HOOK"

# ==========================
# Ensure ~/.local/bin exists
# ==========================
mkdir -p "$BINPATH"

# ==========================
# Ensure resync-session exists
# ==========================
if [ ! -f "$RESYNC" ]; then
  cat <<EOF > "$RESYNC"
#!/usr/bin/env sh
set -e

# Session modules will be injected below

EOF
  chmod +x "$RESYNC"
fi

# ==========================
# Update resync-session (idempotent)
# ==========================
sed -i '/# monitor setup start/,/# monitor setup end/d' "$RESYNC"

cat <<EOF >> "$RESYNC"

# monitor setup start
"$TARGET_SCRIPT"
# monitor setup end
EOF

echo "monitor-setup hook added to resync-session."

echo
echo "Display configuration installed"
