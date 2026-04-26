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

# AMD drivers (kernel + userspace)
ensure_pkg xf86-video-amdgpu
ensure_pkg vulkan-radeon

# Video acceleration
ensure_pkg libva-mesa-driver

# Tools (optional but useful)
ensure_pkg mesa-utils
ensure_pkg vulkan-tools

echo "AMD GPU stack installed"
echo "Verify with: glxinfo | grep 'OpenGL renderer'"
