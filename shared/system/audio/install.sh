#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

LOCAL_BIN="$HOME/.local/bin"
SCRIPT_SOURCE="$SCRIPT_DIR/pavucontrol"
INSTALL_TARGET="$LOCAL_BIN/pavucontrol"

ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

echo "Installing PipeWire audio stack..."

# ==========================
# Core audio stack
# ==========================
ensure_pkg pipewire
ensure_pkg wireplumber

# ==========================
# Compatibility layers
# ==========================
ensure_pkg pipewire-alsa
ensure_pkg pipewire-pulse
ensure_pkg pipewire-jack

# ==========================
# User tools
# ==========================
ensure_pkg pavucontrol

# ==========================
# GTK theme (for dark mode)
# ==========================
ensure_pkg gtk3

# ==========================
# Enable user services
# ==========================
systemctl --user enable --now pipewire pipewire-pulse wireplumber || true

# ==========================
# Install wrapper
# ==========================
mkdir -p "$LOCAL_BIN"

if [ -f "$SCRIPT_SOURCE" ]; then
    chmod +x "$SCRIPT_SOURCE"
    ln -sf "$SCRIPT_SOURCE" "$INSTALL_TARGET"
    echo "pavucontrol wrapper installed → $INSTALL_TARGET"
else
    echo "Wrapper script not found, skipping"
fi

echo ""
echo "Audio setup complete"
echo "If audio is not working, log out and back in"
