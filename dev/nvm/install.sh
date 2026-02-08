#!/usr/bin/env sh
set -e

# ==========================
# NVM (Node Version Manager)
# ==========================

NVM_DIR="$HOME/.nvm"
ZSHRC="$HOME/.zshrc"

NVM_INIT_BLOCK='
# Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
'

# --------------------------
# Dependencies
# --------------------------

if ! command -v curl >/dev/null 2>&1; then
  echo "❌ curl is required"
  echo "Install it with: sudo pacman -S curl"
  exit 1
fi

# --------------------------
# Install nvm (if missing)
# --------------------------

if [ ! -d "$NVM_DIR" ]; then
  echo "Installing nvm"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "nvm already installed"
fi

# --------------------------
# Ensure Zsh init block exists
# --------------------------

if [ -f "$ZSHRC" ]; then
  if ! grep -q 'NVM_DIR="$HOME/.nvm"' "$ZSHRC"; then
    echo "Adding nvm init block to .zshrc"
    echo "$NVM_INIT_BLOCK" >> "$ZSHRC"
  else
    echo "✔ nvm already sourced in .zshrc"
  fi
else
  echo "~/.zshrc not found — skipping shell integration"
fi

# --------------------------
# Done
# --------------------------

echo ""
echo "nvm setup complete"
echo "Restart your shell or run: source ~/.zshrc"
