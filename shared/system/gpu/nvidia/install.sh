#!/usr/bin/env bash
set -e

ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# Core NVIDIA stack
ensure_pkg linux-headers
ensure_pkg nvidia-open
ensure_pkg nvidia-utils

# Tools
ensure_pkg nvidia-settings
ensure_pkg nvtop

# Rebuild initramfs
sudo mkinitcpio -P

echo "Reboot and verify with: nvidia-smi"
