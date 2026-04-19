#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

# -------------------------
# Configurable variables
# -------------------------
OPACITY=85
ALACRITTY_OPACITY="0.$OPACITY"
TITLE="main-terminal"

# -------------------------
# Ensure directories exist
# -------------------------
mkdir -p "$BIN_DIR" "$DESKTOP_DIR"

# -------------------------
# Create launcher script
# -------------------------
cat > "$BIN_DIR/main-terminal" <<EOF
#!/usr/bin/env sh
exec alacritty --title $TITLE -o window.opacity=$ALACRITTY_OPACITY
EOF

chmod +x "$BIN_DIR/main-terminal"

# -------------------------
# Install desktop entry
# -------------------------
cat > "$DESKTOP_DIR/main-terminal.desktop" <<EOF
[Desktop Entry]
Name=Main Terminal
Exec=main-terminal
Type=Application
Categories=Terminal;
Terminal=false
EOF

echo "Main Terminal installed"

# -------------------------
# Picom rule via helper
# -------------------------
if ! command -v add-opacity-rule >/dev/null 2>&1; then
    echo "add-opacity-rule not found. Run picom install first."
    exit 1
fi

add-opacity-rule "$OPACITY:class_g = 'Alacritty' && name *= '$TITLE'"

echo "picom rule added"

echo "Setup complete"
