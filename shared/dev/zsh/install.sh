#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_SRC="$SCRIPT_DIR/.zshrc"
ZSHRC_DEST="$HOME/.zshrc"
CONF_DIR="$HOME/.config/zsh/conf.d"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg zsh
ensure_pkg git
ensure_pkg curl

# ==========================
# Set default shell
# ==========================
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Setting zsh as default shell"
    chsh -s "$(command -v zsh)"
else
    echo "zsh already default shell"
fi

# ==========================
# Install Oh My Zsh
# ==========================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh"
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed"
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"

# ==========================
# Plugins
# ==========================
clone_plugin() {
    local repo="$1"
    local dir="$2"

    if [ ! -d "$dir" ]; then
        echo "Installing $(basename "$dir")"
        git clone --depth=1 "$repo" "$dir"
    else
        echo "$(basename "$dir") already installed"
    fi
}

clone_plugin https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/zsh-autosuggestions"

clone_plugin https://github.com/zdharma-continuum/fast-syntax-highlighting \
    "$ZSH_CUSTOM/fast-syntax-highlighting"

# ==========================
# CONFD directory
# ==========================
mkdir -p "$CONF_DIR" 

# ==========================
# Link .zshrc
# ==========================
if [ ! -f "$ZSHRC_SRC" ]; then
    echo "Missing $ZSHRC_SRC"
    exit 1
fi

if [ -f "$ZSHRC_DEST" ] && [ ! -L "$ZSHRC_DEST" ]; then
    echo "Backing up existing .zshrc"
    mv "$ZSHRC_DEST" "$ZSHRC_DEST.bak"
fi

echo "Linking .zshrc"
ln -sf "$ZSHRC_SRC" "$ZSHRC_DEST"

# ==========================
# Done
# ==========================
echo
echo "Zsh environment installed"
echo "Log out and log back in to start using zsh"
