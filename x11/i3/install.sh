#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_SOURCE="$SCRIPT_DIR/config"
TARGET_DIR="$HOME/.config/i3"
TARGET_CONFIG="$TARGET_DIR/config"

XINITRC="$HOME/.xinitrc"
X11_CONF_DIR="$HOME/.config/x11/conf.d"

ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg i3-wm

if [ ! -f "$CONFIG_SOURCE" ]; then
    echo "Missing i3 config:"
    echo "$CONFIG_SOURCE"
    exit 1
fi

mkdir -p "$TARGET_DIR"
mkdir -p "$X11_CONF_DIR"

# backup if user already modified it
if [ -f "$TARGET_CONFIG" ] && [ ! -L "$TARGET_CONFIG" ]; then
    TS=$(date +"%Y%m%d-%H%M%S")
    mv "$TARGET_CONFIG" "${TARGET_CONFIG}.bak-$TS"
    echo "Backed up existing i3 config"
fi

cp "$CONFIG_SOURCE" "$TARGET_CONFIG"
echo "Installed fresh i3 config"

cat > "$XINITRC" << 'EOF'
#!/usr/bin/env sh

CONF_DIR="$HOME/.config/x11/conf.d"

for file in "$CONF_DIR/"*.sh; do
    [ -x "$file" ] && "$file"
done

exec i3
EOF

chmod +x "$XINITRC"
echo "Created ~/.xinitrc for i3"

echo
echo "i3 installed"
echo "install dmenu next then"
echo "Run: startx"
