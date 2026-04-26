#!/usr/bin/env bash
set -e

ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# Core graphics stack
ensure_pkg mesa
ensure_pkg lib32-mesa

# Video acceleration
ensure_pkg libva-intel-driver
ensure_pkg intel-media-driver

# Tools (optional but useful)
ensure_pkg vulkan-intel
ensure_pkg intel-gpu-tools

echo "Intel GPU stack installed"
echo "Verify with: glxinfo | grep 'OpenGL renderer'"
