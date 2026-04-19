#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

I3_CONFIG_DIR="$HOME/.config/i3"
I3_CONFIG="$I3_CONFIG_DIR/config"

# -------------------------
# Configurable variables
# -------------------------
OPACITY=95
ALACRITTY_OPACITY="0.$OPACITY"
TITLE="scratch-terminal"

# -------------------------
# Ensure dirs exist
# -------------------------
mkdir -p "$BIN_DIR" "$DESKTOP_DIR" "$I3_CONFIG_DIR"

# -------------------------
# Create launcher script
# -------------------------
cat > "$BIN_DIR/scratch-terminal" <<EOF
#!/usr/bin/env sh
exec alacritty --title $TITLE -o window.opacity=$ALACRITTY_OPACITY
EOF

chmod +x "$BIN_DIR/scratch-terminal"

# -------------------------
# Install desktop entry
# -------------------------
cat > "$DESKTOP_DIR/scratch-terminal.desktop" <<EOF
[Desktop Entry]
Name=Scratch Terminal
Exec=scratch-terminal
Type=Application
Categories=Terminal;
Terminal=false
EOF

echo "Scratch Terminal installed"

# -------------------------
# i3 CONFIG
# -------------------------
touch "$I3_CONFIG"

sed -i '/# scratch terminal start/,/# scratch terminal end/d' "$I3_CONFIG"

cat >> "$I3_CONFIG" <<EOF

# scratch terminal start
for_window [class="Alacritty" title="$TITLE"] floating enable, resize set 70 ppt 70 ppt, move position center, move scratchpad
bindsym \$mod+backslash [title="$TITLE"] scratchpad show
# scratch terminal end

EOF

echo "i3 config updated"

# -------------------------
# PICOM RULE (via helper)
# -------------------------
if ! command -v add-opacity-rule >/dev/null 2>&1; then
    echo "add-opacity-rule not found. Run picom install first."
    exit 1
fi

add-opacity-rule "$OPACITY:class_g = 'Alacritty' && name *= '$TITLE'"

echo "picom rule added"

# -------------------------
# Reload picom
# -------------------------
if pgrep -x picom >/dev/null; then
    pkill picom
    picom &
fi

echo "Scratch setup complete"
