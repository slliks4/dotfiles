#!/usr/bin/env sh
set -e

# ==========================
# Paths & filenames
# ==========================

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Module paths
DOTFILES_DIR="$SCRIPT_DIR"
CONFIG_DIR="$HOME/.config/system/input"
SCRIPT_NAME="trackpad.sh"

TARGET_SCRIPT="$CONFIG_DIR/$SCRIPT_NAME"
XINITRC="$HOME/.xinitrc"
 
BINPATH="$HOME/.local/bin"
RESYNC="$BINPATH/resync-session"

# ==========================
# Dependency check
# ==========================
# xinput is required for libinput configuration

if ! command -v xinput >/dev/null 2>&1; then
  echo "📦 Installing missing dependency: xorg-xinput"
  sudo pacman -S --needed xorg-xinput
fi

# ==========================
# Create config directory
# ==========================
mkdir -p "$CONFIG_DIR"

# ==========================
# Symlink trackpad script
# ==========================
# Single source of truth lives in dotfiles repo

ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"
chmod +x "$TARGET_SCRIPT"

# ==========================
# Ensure ~/.xinitrc exists
# ==========================
if [ ! -f "$XINITRC" ]; then
  touch "$XINITRC"
  chmod +x "$XINITRC"
fi

# ==========================
# Remove old trackpad entries (idempotent)
# ==========================
sed -i '/trackpad\.sh/d' "$XINITRC"
sed -i '/# Trackpad setup/d' "$XINITRC"

# ==========================
# Insert trackpad hook BEFORE exec dwm
# ==========================
if grep -q "^exec dwm" "$XINITRC"; then
  sed -i "/^exec dwm/i\\
# Trackpad setup\n\"$TARGET_SCRIPT\"\n" "$XINITRC"
else
  # If exec dwm is missing, append safely
  {
    echo ""
    echo "# Trackpad setup"
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
# Remove old trackpad block (idempotent)
# ==========================
sed -i '/# Trackpad setup start/,/# Trackpad setup end/d' "$RESYNC"

# ==========================
# Append trackpad block
# ==========================
cat <<EOF >> "$RESYNC"

# Trackpad setup start
"$TARGET_SCRIPT"
# Trackpad setup end
EOF

echo "Trackpad hook added to resync-session."

echo "Trackpad configuration installed."
