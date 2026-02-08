#!/usr/bin/env bash
set -e

# ==============================
# pyenv installer
# ==============================

PYENV_ROOT="$HOME/.pyenv"
ZSHRC="$HOME/.zshrc"

# ------------------------------
# Dependency helpers
# ------------------------------
check_dep() {
  command -v "$1" >/dev/null 2>&1
}

install_pkgs=""

# ------------------------------
# Python build dependencies
# ------------------------------
deps=(
  base-devel
  openssl
  zlib
  xz
  libffi
  readline
  sqlite
  tk
)

for pkg in "${deps[@]}"; do
  pacman -Qi "$pkg" >/dev/null 2>&1 || install_pkgs+=" $pkg"
done

# ------------------------------
# Install dependencies
# ------------------------------
if [ -n "$install_pkgs" ]; then
  echo "==> Installing Python build dependencies:$install_pkgs"
  sudo pacman -S --needed --noconfirm $install_pkgs
else
  echo "==> Python build dependencies already installed"
fi

# ------------------------------
# Install pyenv
# ------------------------------
if [ ! -d "$PYENV_ROOT" ]; then
  echo "==> Installing pyenv"
  git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
else
  echo "==> pyenv already installed"
fi

# ------------------------------
# Ensure .zshrc exists
# ------------------------------
if [ ! -f "$ZSHRC" ]; then
  touch "$ZSHRC"
fi

# ------------------------------
# Append pyenv init to .zshrc (idempotent)
# ------------------------------
append_if_missing() {
  local line="$1"
  grep -qxF "$line" "$ZSHRC" || echo "$line" >> "$ZSHRC"
}

echo "==> Configuring pyenv in .zshrc"

append_if_missing ""
append_if_missing "# pyenv"
append_if_missing "export PYENV_ROOT=\"\$HOME/.pyenv\""
append_if_missing "export PATH=\"\$PYENV_ROOT/bin:\$PATH\""
append_if_missing "eval \"\$(pyenv init -)\""

# ------------------------------
# Done
# ------------------------------
echo
echo "✅ pyenv installed"
echo "➡ Restart your shell or run: source ~/.zshrc"
echo "➡ Then install a Python version with: pyenv install <version>"
