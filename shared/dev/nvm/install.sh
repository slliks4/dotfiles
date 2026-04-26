#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
NVM_DIR="$HOME/.nvm"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg curl

# ==========================
# Install nvm (upstream)
# ==========================
if [ ! -d "$NVM_DIR" ]; then
    echo "Installing nvm"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
    echo "nvm already installed"
fi

# ==========================
# Done
# ==========================
echo "nvm installed"
echo "Restart your shell or run:"
echo "source ~/.zshrc"
