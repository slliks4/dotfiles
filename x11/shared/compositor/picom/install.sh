#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/picom"

BASE_CONFIG_SRC="$SCRIPT_DIR/picom.base.conf"
BASE_CONFIG_TARGET="$CONFIG_DIR/picom.base.conf"

FINAL_CONFIG="$CONFIG_DIR/picom.conf"

CONF_D_DIR="$CONFIG_DIR/conf.d"
BUILD_SCRIPT="$CONFIG_DIR/build.sh"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
PICOM_HOOK="$X11_CONF_DIR/picom.sh"

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

ensure_pkg picom

# ==========================
# Setup directories
# ==========================
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONF_D_DIR"

if [ -L "$FINAL_CONFIG" ]; then
    echo "Removing stale symlink: $FINAL_CONFIG"
    rm "$FINAL_CONFIG"
fi

# ==========================
# Install base config
# ==========================
ln -sf "$BASE_CONFIG_SRC" "$BASE_CONFIG_TARGET"

# ==========================
# Install build script
# ==========================
ln -sf "$SCRIPT_DIR/build.sh" "$BUILD_SCRIPT"
chmod +x "$BUILD_SCRIPT"

# ==========================
# Setup X11 hook
# ==========================
mkdir -p "$X11_CONF_DIR"

cat > "$PICOM_HOOK" << EOF
#!/usr/bin/env sh

# Build config before launch
"$BUILD_SCRIPT"

# Restart picom cleanly
pkill picom 2>/dev/null || true
picom --config "$FINAL_CONFIG" &
EOF

chmod +x "$PICOM_HOOK"

echo "Picom hook installed -> $PICOM_HOOK"

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
sed -i '/# picom start/,/# picom end/d' "$RESYNC"

cat <<EOF >> "$RESYNC"

# picom start
"$BUILD_SCRIPT"
pkill picom 2>/dev/null || true
picom --config "$FINAL_CONFIG" &
# picom end
EOF

echo "Picom added to resync-session"

echo
echo "Picom installed"
echo "Run 'resync-session' or relog to apply changes"
