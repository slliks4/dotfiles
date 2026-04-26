#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/system/keyboard"
SCRIPT_NAME="keyboard.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
KEYBOARD_HOOK="$X11_CONF_DIR/keyboard.sh"

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

# xset → xorg-xset
# setxkbmap → xorg-setxkbmap
ensure_pkg xorg-xset
ensure_pkg xorg-setxkbmap

# ==========================
# Create config directory
# ==========================
mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink keyboard script
# ==========================
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# ==========================
# Setup X11 conf.d hook
# ==========================
mkdir -p "$X11_CONF_DIR"

cat > "$KEYBOARD_HOOK" << EOF
#!/usr/bin/env sh
"$TARGET_SCRIPT"
EOF

chmod +x "$KEYBOARD_HOOK"

echo "Keyboard hook installed -> $KEYBOARD_HOOK"

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
sed -i '/# keyboard setup start/,/# keyboard setup end/d' "$RESYNC"

cat <<EOF >> "$RESYNC"

# keyboard setup start
"$TARGET_SCRIPT"
# keyboard setup end
EOF

echo "Keyboard hook added to resync-session."

echo
echo "Keyboard configuration installed"
