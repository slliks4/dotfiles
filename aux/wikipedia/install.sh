#!/usr/bin/env bash
set -euo pipefail

# ------------------------------
# Paths
# ------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WIKIIQ_SRC="$SCRIPT_DIR/wikiiq"
BIN_DIR="$HOME/.local/bin"

ZSHRC="$HOME/.zshrc"
ALIAS_WIKI='alias wiki="wiki-tui"'

# ------------------------------
# Helpers
# ------------------------------
check_dep() {
    command -v "$1" >/dev/null 2>&1
}

# ------------------------------
# Dependency check (Arch)
# ------------------------------
install_pkgs=()

check_dep wiki-tui     || install_pkgs+=("wiki-tui")
check_dep qutebrowser  || install_pkgs+=("qutebrowser")
check_dep jq           || install_pkgs+=("jq")
check_dep xclip        || install_pkgs+=("xclip")

# ------------------------------
# Install packages
# ------------------------------
if [ "${#install_pkgs[@]}" -gt 0 ]; then
    echo "==> Installing packages: ${install_pkgs[*]}"
    sudo pacman -S --needed --noconfirm "${install_pkgs[@]}"
else
    echo "==> All dependencies already installed"
fi

# ------------------------------
# Install wikiiq
# ------------------------------
if [ -f "$WIKIIQ_SRC" ]; then
    chmod +x "$WIKIIQ_SRC"

    sudo ln -sf "$WIKIIQ_SRC" "$BIN_DIR"

    echo "Installed wikiiq → $BIN_DIR"
else
    echo "wikiiq script not found at $WIKIIQ_SRC"
    echo "Skipping wikiiq install"
fi

# ------------------------------
# Shell alias (wiki-tui only)
# ------------------------------
if [ -f "$ZSHRC" ]; then
    if ! grep -qxF "$ALIAS_WIKI" "$ZSHRC"; then
        {
            echo ""
            echo "# wiki tools"
            echo "$ALIAS_WIKI"
        } >> "$ZSHRC"
        echo "Added wiki alias to .zshrc"
    else
        echo "wiki alias already present"
    fi
else
    echo ".zshrc not found, skipping alias setup"
fi

echo "wiki tools setup complete"
