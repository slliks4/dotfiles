#!/usr/bin/env bash
set -e

# ==============================
# Zsh / Oh My Zsh installer
# ==============================

DOTFILES_DIR="$HOME/.dotfiles"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHRC_SRC="$SCRIPT_DIR/.zshrc"
ZSHRC_DEST="$HOME/.zshrc"

# ------------------------------
# Dependency helpers
# ------------------------------
check_dep() {
  command -v "$1" >/dev/null 2>&1
}

install_pkgs=""

# ------------------------------
# Collect missing dependencies
# ------------------------------
check_dep zsh  || install_pkgs+=" zsh"
check_dep git  || install_pkgs+=" git"
check_dep curl || install_pkgs+=" curl"

check_dep nvim || install_pkgs+=" neovim"
check_dep fzf  || install_pkgs+=" fzf"
check_dep rg   || install_pkgs+=" ripgrep"

# ------------------------------
# Install packages
# ------------------------------
if [ -n "$install_pkgs" ]; then
  echo "==> Installing packages:$install_pkgs"
  sudo pacman -S --needed --noconfirm $install_pkgs
else
  echo "==> All dependencies already installed"
fi

# ------------------------------
# Set zsh as default shell
# ------------------------------
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "==> Setting zsh as default shell"
  chsh -s "$(command -v zsh)"
fi

# ------------------------------
# Install Oh My Zsh
# ------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "==> Oh My Zsh already installed"
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom/plugins"

# ------------------------------
# Install plugins
# ------------------------------
clone_plugin() {
  local repo="$1"
  local dir="$2"

  if [ ! -d "$dir" ]; then
    echo "==> Installing $(basename "$dir")"
    git clone --depth=1 "$repo" "$dir"
  else
    echo "==> $(basename "$dir") already installed"
  fi
}

clone_plugin https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/zsh-autosuggestions"

clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/zsh-syntax-highlighting"

clone_plugin https://github.com/zdharma-continuum/fast-syntax-highlighting \
  "$ZSH_CUSTOM/fast-syntax-highlighting"

# ------------------------------
# Link .zshrc
# ------------------------------
if [ ! -f "$ZSHRC_SRC" ]; then
  echo "❌ Missing $ZSHRC_SRC"
  exit 1
fi

if [ -f "$ZSHRC_DEST" ] && [ ! -L "$ZSHRC_DEST" ]; then
  echo "==> Backing up existing .zshrc"
  mv "$ZSHRC_DEST" "$ZSHRC_DEST.bak"
fi

echo "==> Linking .zshrc"
ln -sf "$ZSHRC_SRC" "$ZSHRC_DEST"

# ------------------------------
# Done
# ------------------------------
echo
echo "✅ Zsh environment installed"
echo "➡ Log out and log back in to start using zsh"
