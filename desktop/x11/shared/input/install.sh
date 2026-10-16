#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/system/input"
SCRIPT_NAME="trackpad.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
INPUT_HOOK="$X11_CONF_DIR/input.sh"

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

ensure_pkg xorg-xinput

# ==========================
# Create config directory
# ==========================
mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink trackpad script
# ==========================
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

# ==========================
# Setup X11 conf.d hook
# ==========================
mkdir -p "$X11_CONF_DIR"

cat > "$INPUT_HOOK" << EOF
#!/usr/bin/env sh
"$TARGET_SCRIPT"
EOF

chmod +x "$INPUT_HOOK"

echo "Input hook installed -> $INPUT_HOOK"

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
sed -i '/# input setup start/,/# input setup end/d' "$RESYNC"

cat <<EOF >> "$RESYNC"

# input setup start
"$TARGET_SCRIPT"
# input setup end
EOF

echo "Trackpad hook added to resync-session."

echo
echo "Input (trackpad) configuration installed"
