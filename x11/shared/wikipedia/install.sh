#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
WIKIIQ_SRC="$SCRIPT_DIR/wikiiq"
WIKIIQ_TARGET="$BIN_DIR/wikiiq"

ZSH_CONF_DIR="$HOME/.config/zsh/conf.d"
WIKI_ALIAS_FILE="$ZSH_CONF_DIR/wiki.zsh"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg wiki-tui
ensure_pkg qutebrowser
ensure_pkg jq
ensure_pkg xclip

# ==========================
# Install wikiiq
# ==========================
mkdir -p "$BIN_DIR"

if [ ! -f "$WIKIIQ_SRC" ]; then
    echo "Missing wikiiq script: $WIKIIQ_SRC"
    exit 1
fi

chmod +x "$WIKIIQ_SRC"
ln -sf "$WIKIIQ_SRC" "$WIKIIQ_TARGET"

echo "wikiiq installed -> $WIKIIQ_TARGET"

# ==========================
# Shell config (conf.d)
# ==========================
mkdir -p "$ZSH_CONF_DIR"

if [ ! -f "$WIKI_ALIAS_FILE" ]; then
    echo "Creating wiki shell config -> $WIKI_ALIAS_FILE"

    cat > "$WIKI_ALIAS_FILE" << 'EOF'
alias wiki="wiki-tui"
EOF
else
    echo "wiki shell config already exists"
fi

# ==========================
# Done
# ==========================
echo "Wiki tools installed"
