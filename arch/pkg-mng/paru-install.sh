#!/usr/bin/env sh
set -e

AUR_DIR="$HOME/aur"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg less
ensure_pkg git

# base-devel is a group
sudo pacman -S --needed --noconfirm base-devel

# --------------------------------------------------
# Install paru (AUR helper) if missing
# --------------------------------------------------

if ! command -v paru >/dev/null 2>&1; then
    echo "Installing paru (AUR helper)"

    mkdir -p "$AUR_DIR"
    cd "$AUR_DIR" || exit 1

    if [ ! -d paru ]; then
        git clone https://aur.archlinux.org/paru.git
    fi

    cd paru || exit 1
    makepkg -si --noconfirm
else
    echo "paru already installed"
fi
