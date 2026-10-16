#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
GUARD_SCRIPT="browser-guard.sh"
TARGET_GUARD="$BIN_DIR/browser-guard"

EDGE_SCRIPT="$BIN_DIR/edge-media"

AUR_DIR="$HOME/.cache/aur"

ensure_pacman_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# Required for building AUR packages
sudo pacman -S --needed --noconfirm base-devel
ensure_pacman_pkg git

# ==========================
# Ensure paru exists
# ==========================
if ! command -v paru >/dev/null 2>&1; then
    echo "Installing paru (AUR helper)"

    mkdir -p "$AUR_DIR"
    cd "$AUR_DIR"

    if [ ! -d paru ]; then
        git clone https://aur.archlinux.org/paru.git
    fi

    cd paru
    makepkg -si --noconfirm
fi

# ==========================
# Dependencies helper
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1 && ! paru -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        paru -S --noconfirm "$1"
    fi
}

# ==========================
# Install browsers
# ==========================
ensure_pkg zen-browser-bin
ensure_pkg firefox-developer-edition
ensure_pkg qutebrowser
ensure_pkg microsoft-edge-stable

# ==========================
# Install browser-guard
# ==========================
mkdir -p "$BIN_DIR"

chmod +x "$SCRIPT_DIR/$GUARD_SCRIPT"
ln -sf "$SCRIPT_DIR/$GUARD_SCRIPT" "$TARGET_GUARD"

echo "browser-guard installed -> $TARGET_GUARD"

# ==========================
# Edge media launcher
# ==========================
cat > "$EDGE_SCRIPT" << 'EOF'
#!/usr/bin/env sh

# Force dark UI for this app only
export GTK_THEME=Adwaita:dark

exec microsoft-edge-stable \
  --user-data-dir="$HOME/.config/edge-media" \
  --no-first-run \
  --no-default-browser-check \
  --disable-features=msEdgeStartupBoost \
  --disable-background-networking \
  --disable-sync \
  --disable-extensions \
  --disable-component-update \
  --disable-features=Translate \
  --force-dark-mode \
  "$@"
EOF

chmod +x "$EDGE_SCRIPT"

echo "edge-media installed -> $EDGE_SCRIPT"

# ==========================
# Done
# ==========================
echo "Browsers installed"
