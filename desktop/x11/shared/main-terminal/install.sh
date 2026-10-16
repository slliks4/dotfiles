#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
PICOM_CONF_DIR="$HOME/.config/picom/conf.d"

# -------------------------
# Configurable variables
# -------------------------
OPACITY=85
ALACRITTY_OPACITY="0.$OPACITY"
TITLE="main-terminal"

RULE_FILE="$PICOM_CONF_DIR/main-terminal.conf"

# -------------------------
# Ensure directories exist
# -------------------------
mkdir -p "$BIN_DIR" "$DESKTOP_DIR" "$PICOM_CONF_DIR"

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
# Picom rule (new system)
# -------------------------
cat > "$RULE_FILE" <<EOF
"$OPACITY:class_g = 'Alacritty' && name *= '$TITLE'",
EOF

echo "Picom rule installed -> $RULE_FILE"

# -------------------------
# Done
# -------------------------
echo
echo "Run 'resync-session' or relog to apply changes"
