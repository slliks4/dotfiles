#!/usr/bin/env bash
set -e

# ==========================
# Resolve paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
NVIM_DIR="$CONFIG_DIR/nvim"
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"

# zsh modular config directory (repo-relative)
ZSH_CONF_DIR="$HOME/.config/zsh/conf.d"
NVIM_ALIAS_FILE="$ZSH_CONF_DIR/nvim.zsh"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg neovim
ensure_pkg git
ensure_pkg ripgrep   # Telescope searching
ensure_pkg fd        # faster file finding
ensure_pkg unzip     # Mason uses this
ensure_pkg curl      # Mason downloads servers


if [ ! -d "$PACKER_DIR" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
    echo "Installed packer.nvim"
else
    echo "packer.nvim already installed"
fi

# ==========================
# Shell config (conf.d)
# ==========================
mkdir -p "$ZSH_CONF_DIR"

if [ ! -f "$NVIM_ALIAS_FILE" ]; then
    echo "Creating nvim shell config -> $NVIM_ALIAS_FILE"

    cat > "$NVIM_ALIAS_FILE" << 'EOF'
alias vi=nvim
alias vim=nvim
EOF
else
    echo "nvim shell config already exists"
fi

# ==========================
# Ensure config directory
# ==========================
mkdir -p "$CONFIG_DIR"

# ==========================
# Backup existing config
# ==========================
if [ -e "$NVIM_DIR" ] && [ ! -L "$NVIM_DIR" ]; then
    TS=$(date +"%F-%H%M%S")
    mv "$NVIM_DIR" "${NVIM_DIR}.bak-$TS"
    echo "Backed up existing nvim config -> ${NVIM_DIR}.bak-$TS"
fi

# ==========================
# Remove incorrect symlink
# ==========================
if [ -L "$NVIM_DIR" ]; then
    rm "$NVIM_DIR"
fi

# ==========================
# Symlink config
# ==========================
ln -s "$SCRIPT_DIR" "$NVIM_DIR"
echo "Symlinked $SCRIPT_DIR -> $NVIM_DIR"

# ==========================
# Done
# ==========================
echo
echo "Neovim installed"
echo "Restart shell or run: source ~/.zshrc"
echo "Done. Open nvim and run :PackerSync"
