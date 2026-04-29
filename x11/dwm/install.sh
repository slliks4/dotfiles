#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
DWM_SRC_DIR="/usr/local/src/dwm"
DWM_REPO="https://github.com/slliks4/dwm.git"

XINITRC="$HOME/.xinitrc"
X11_CONF_DIR="$HOME/.config/x11/conf.d"

# ==========================
# Helpers
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# ==========================
# Dependencies
# ==========================
ensure_pkg xorg-server
ensure_pkg xorg-xinit
ensure_pkg base-devel
ensure_pkg libx11
ensure_pkg libxinerama
ensure_pkg libxft
ensure_pkg alacritty
ensure_pkg fontconfig
ensure_pkg terminus-font
ensure_pkg git

# ==========================
# Prepare source
# ==========================
sudo mkdir -p /usr/local/src
sudo chown "$USER:$USER" /usr/local/src

# ==========================
# Clone dwm
# ==========================
if [ ! -d "$DWM_SRC_DIR" ]; then
    cd /usr/local/src
    git clone "$DWM_REPO" dwm
else
    echo "dwm source already exists"
fi

# ==========================
# Build & install
# ==========================
cd "$DWM_SRC_DIR"
sudo make clean install

# ==========================
# Ensure shared conf dir exists
# ==========================
mkdir -p "$X11_CONF_DIR"

if [ -f "$XINITRC" ]; then
    TS=$(date +"%Y%m%d-%H%M%S")
    cp "$XINITRC" "$XINITRC.bak-$TS"
    echo "Backed up existing .xinitrc"
fi

# ==========================
# Rewrite .xinitrc (same pattern as i3)
# ==========================
cat > "$XINITRC" << 'EOF'
#!/usr/bin/env sh

CONF_DIR="$HOME/.config/x11/conf.d"

for file in "$CONF_DIR/"*.sh; do
    [ -x "$file" ] && "$file"
done

export WM=dwm
exec dwm
EOF

chmod +x "$XINITRC"

echo "Created ~/.xinitrc for dwm"

# ==========================
# Done
# ==========================
echo
echo "dwm installed"
echo "Run: startx"
