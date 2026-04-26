#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

CONFIG_DIR="$HOME/.config/zathura"
CONFIG_SRC="$SCRIPT_DIR/zathurarc"
CONFIG_TARGET="$CONFIG_DIR/zathurarc"

ZSH_CONF_DIR="$HOME/.config/zsh/conf.d"
ZATHURA_ALIAS_FILE="$ZSH_CONF_DIR/zathura.zsh"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg zathura
ensure_pkg zathura-pdf-mupdf

# ==========================
# Config
# ==========================
mkdir -p "$CONFIG_DIR"

if [ ! -f "$CONFIG_SRC" ]; then
    echo "Missing config: $CONFIG_SRC"
    exit 1
fi

ln -sf "$CONFIG_SRC" "$CONFIG_TARGET"
echo "Zathura config linked -> $CONFIG_TARGET"

# ==========================
# Shell config (conf.d)
# ==========================
mkdir -p "$ZSH_CONF_DIR"

if [ ! -f "$ZATHURA_ALIAS_FILE" ]; then
    echo "Creating zathura shell config -> $ZATHURA_ALIAS_FILE"

    cat > "$ZATHURA_ALIAS_FILE" << 'EOF'
alias pdf="zathura"
EOF
else
    echo "zathura shell config already exists"
fi

# ==========================
# Done
# ==========================
echo "Zathura installed"
