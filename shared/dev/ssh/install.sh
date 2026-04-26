#!/usr/bin/env bash
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

ensure_pkg openssh

# ==========================
# Enable + Start SSH
# ==========================
echo "Enabling SSH service..."
sudo systemctl enable sshd

echo "Starting SSH service..."
sudo systemctl start sshd

# ==========================
# Status check
# ==========================
echo
echo "SSH status:"
systemctl status sshd --no-pager

echo
echo "SSH installed and running"
echo "Use: ssh user@hostname"
