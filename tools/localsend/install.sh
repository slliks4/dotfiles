#!/usr/bin/env sh
set -e

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

# Ensure paru exists
if ! command -v paru >/dev/null 2>&1; then
    echo "Installing paru (AUR helper)"

    mkdir -p "$AUR_DIR"
    cd "$AUR_DIR" || exit 1

    if [ ! -d paru ]; then
        git clone https://aur.archlinux.org/paru.git
    fi

    cd paru || exit 1
    makepkg -si --noconfirm
fi

# Now safe to use paru
ensure_pkg() {
    if ! paru -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        paru -S --noconfirm "$1"
    fi
}

ensure_pkg localsend

echo "localsend installed"
