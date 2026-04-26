#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
PYENV_ROOT="$HOME/.pyenv"

ZSH_CONF_DIR="$HOME/.config/zsh/conf.d"
PYENV_CONF_FILE="$ZSH_CONF_DIR/pyenv.zsh"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

# Python build deps (Arch)
ensure_pkg base-devel
ensure_pkg openssl
ensure_pkg zlib
ensure_pkg xz
ensure_pkg libffi
ensure_pkg readline
ensure_pkg sqlite
ensure_pkg tk
ensure_pkg git

# ==========================
# Install pyenv
# ==========================
if [ ! -d "$PYENV_ROOT" ]; then
    echo "Installing pyenv"
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
else
    echo "pyenv already installed"
fi

# ==========================
# Shell config (conf.d)
# ==========================
mkdir -p "$ZSH_CONF_DIR"

if [ ! -f "$PYENV_CONF_FILE" ]; then
    echo "Creating pyenv shell config -> $PYENV_CONF_FILE"

    cat > "$PYENV_CONF_FILE" << 'EOF'
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# initialize pyenv
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
EOF
else
    echo "pyenv shell config already exists"
fi

# ==========================
# Done
# ==========================
echo "pyenv installed"
echo "Restart your shell"
echo "Then install Python with: pyenv install <version>"
