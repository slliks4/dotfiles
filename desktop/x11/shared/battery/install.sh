#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"

SCRIPT_MODE="battery-mode"
SCRIPT_NOTIFY="battery-notify"

TARGET_MODE="$BIN_DIR/$SCRIPT_MODE"
TARGET_NOTIFY="$BIN_DIR/$SCRIPT_NOTIFY"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
BATTERY_HOOK="$X11_CONF_DIR/battery.sh"

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

ensure_pkg power-profiles-daemon
ensure_pkg light
ensure_pkg libnotify
ensure_pkg python
ensure_pkg python-gobject

# ==========================
# Enable power profiles
# ==========================
sudo systemctl enable power-profiles-daemon --now

# ==========================
# Ensure bin dir
# ==========================
mkdir -p "$BIN_DIR"

# ==========================
# Symlink scripts
# ==========================
ln -sf "$SCRIPT_DIR/$SCRIPT_MODE" "$TARGET_MODE"
chmod +x "$TARGET_MODE"

ln -sf "$SCRIPT_DIR/$SCRIPT_NOTIFY" "$TARGET_NOTIFY"
chmod +x "$TARGET_NOTIFY"

echo "battery-mode -> $TARGET_MODE"
echo "battery-notify -> $TARGET_NOTIFY"

# ==========================
# Setup X11 hook
# ==========================
mkdir -p "$X11_CONF_DIR"

cat > "$BATTERY_HOOK" << EOF
#!/usr/bin/env sh

"$TARGET_NOTIFY" &
EOF

chmod +x "$BATTERY_HOOK"

echo "Battery hook installed -> $BATTERY_HOOK"

# ==========================
# Ensure resync-session exists
# ==========================
mkdir -p "$BINPATH"

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
sed -i '/# battery start/,/# battery end/d' "$RESYNC"

cat <<EOF >> "$RESYNC"

# battery start
"$TARGET_NOTIFY" &
# battery end
EOF

echo "Battery added to resync-session"

echo
echo "Battery module installed"
echo "Run 'resync-session' or relog to apply"
