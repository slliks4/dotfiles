#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/system/notifications"
SCRIPT_NAME="dunst.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"

DUNST_CONFIG_DIR="$HOME/.config/dunst"
DUNST_RC_TARGET="$DUNST_CONFIG_DIR/dunstrc"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
NOTIFY_HOOK="$X11_CONF_DIR/notifications.sh"

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

ensure_pkg dunst
ensure_pkg libnotify

# ==========================
# Setup directories
# ==========================
mkdir -p "$CONFIG_DIR"
mkdir -p "$DUNST_CONFIG_DIR"

# ==========================
# Symlink script + config
# ==========================
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

ln -sf "$SCRIPT_DIR/dunstrc" "$DUNST_RC_TARGET"

# ==========================
# Setup X11 conf.d hook
# ==========================
mkdir -p "$X11_CONF_DIR"

cat > "$NOTIFY_HOOK" << EOF
#!/usr/bin/env sh
"$TARGET_SCRIPT"
EOF

chmod +x "$NOTIFY_HOOK"

echo "Notification hook installed -> $NOTIFY_HOOK"

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
# Update resync-session
# ==========================
sed -i '/# notifications start/,/# notifications end/d' "$RESYNC"

cat <<EOF >> "$RESYNC"

# notifications start
"$TARGET_SCRIPT"
# notifications end
EOF

echo "Notifications added to resync-session."

echo
echo "Dunst notifications installed"
