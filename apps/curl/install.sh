#!/usr/bin/env sh
set -e

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# ==========================
# Install curl
# ==========================
ensure_pkg curl

echo "curl installed"
