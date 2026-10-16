#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/system/status"
SCRIPT_NAME="status.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"

X11_CONF_DIR="$HOME/.config/x11/conf.d"
HOOK="$X11_CONF_DIR/status.sh"

# ==========================
# Setup
# ==========================
mkdir -p "$CONFIG_DIR"
mkdir -p "$X11_CONF_DIR"

# ==========================
# Symlink main script
# ==========================
ln -sf "$SCRIPT_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

# ==========================
# Create conf.d hook
# ==========================
cat > "$HOOK" << EOF
#!/usr/bin/env sh

# Only run in dwm
[ "\$WM" = "dwm" ] || exit 0

"$TARGET_SCRIPT" &
EOF

chmod +x "$HOOK"

echo "status bar installed -> $TARGET_SCRIPT"
echo "conf.d hook installed -> $HOOK"
