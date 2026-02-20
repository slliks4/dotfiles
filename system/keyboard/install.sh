#!/usr/bin/env sh
set -e

# ==========================
# Paths & filenames
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Module paths
DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/system/keyboard"
SCRIPT_NAME="keyboard.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
XINITRC="$HOME/.xinitrc"

BINPATH="$HOME/.local/bin"
RESYNC="$BINPATH/resync-session"

# ==========================
# Create config directory
# ==========================

mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink keyboard script
# ==========================
# Single source of truth lives in dotfiles repo

ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# ==========================
# Ensure ~/.xinitrc exists
# ==========================

if [ ! -f "$XINITRC" ]; then
  touch "$XINITRC"
  chmod +x "$XINITRC"
fi

# ==========================
# Remove old keyboard entries (idempotent)
# ==========================

sed -i '/keyboard\.sh/d' "$XINITRC"
sed -i '/# Keyboard setup/d' "$XINITRC"

# ==========================
# Insert keyboard hook BEFORE exec dwm
# ==========================

if grep -q "^exec dwm" "$XINITRC"; then
  sed -i "/^exec dwm/i\\
# Keyboard setup\n\"$TARGET_SCRIPT\"\n" "$XINITRC"
else
  # If exec dwm is missing, append safely
  {
    echo ""
    echo "# Keyboard setup"
    echo "\"$TARGET_SCRIPT\""
  } >> "$XINITRC"
fi

# ==========================
# Ensure ~/.local/bin exists
# ==========================
mkdir -p "$BINPATH"

# ==========================
# Ensure resync-session exists (base template)
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
# Remove old keyboard block (idempotent)
# ==========================
sed -i '/# Keyboard setup start/,/# Keyboard setup end/d' "$RESYNC"

# ==========================
# Append keyboard block
# ==========================
cat <<EOF >> "$RESYNC"

# Keyboard setup start
"$TARGET_SCRIPT"
# Keyboard setup end
EOF

echo "Keyboard hook added to resync-session."

echo "Keyboard configuration installed."
