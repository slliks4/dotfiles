#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TMUX_CONF_SOURCE="$SCRIPT_DIR/.tmux.conf"
TMUX_CONF_TARGET="$HOME/.tmux.conf"
PLUGIN_DIR="$HOME/.tmux/plugins"

echo "Deploying tmux configuration..."

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg git
ensure_pkg tmux
ensure_pkg fzf

# Ensure plugin directory
mkdir -p "$PLUGIN_DIR"

# 1. Create base config if missing
if [ ! -f "$TMUX_CONF_SOURCE" ]; then
  echo ".tmux.conf not found in dotfiles — creating base config..."

  cat > "$TMUX_CONF_SOURCE" << 'EOF'
##### ─────────────────────────────────────────────
##### PLUGIN MANAGER + CORE PLUGINS
##### ─────────────────────────────────────────────

set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'

set -g @continuum-restore 'on'
set -g @resurrect-capture-pane-contents 'on'
set -g @continuum-save-interval '15'

##### ─────────────────────────────────────────────
##### TERMINAL / COLOR BASE
##### ─────────────────────────────────────────────

set -g default-terminal "tmux-256color"
set -as terminal-overrides ",*:Tc"

##### ─────────────────────────────────────────────
##### PLUGIN LOADER
##### ─────────────────────────────────────────────

run '~/.tmux/plugins/tpm/tpm'
EOF

  echo "Base .tmux.conf created"
else
  echo "Existing .tmux.conf found in dotfiles"
fi

# 2. Symlink config
echo "Linking .tmux.conf..."
ln -sf "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"

# 3. Install TPM
TPM_DIR="$PLUGIN_DIR/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed"
fi

# 4. Symlink ts helper
LOCAL_BIN="$HOME/.local/bin"
TS_SOURCE="$SCRIPT_DIR/ts"
TS_TARGET="$LOCAL_BIN/ts"
TSDEV_SOURCE="$SCRIPT_DIR/ts-dev"
TSDEV_TARGET="$LOCAL_BIN/ts-dev"

mkdir -p "$LOCAL_BIN"

if [ -f "$TS_SOURCE" ]; then
  chmod +x "$TS_SOURCE"
  ln -sf "$TS_SOURCE" "$TS_TARGET"
  echo "ts linked → $TS_TARGET"
else
  echo "ts script not found"
fi

if [ -f "$TSDEV_SOURCE" ]; then
  chmod +x "$TSDEV_SOURCE"
  ln -sf "$TSDEV_SOURCE" "$TSDEV_TARGET"
  echo "ts-dev linked → $TSDEV_TARGET"
else
  echo "ts-dev setup script not found"
fi

echo "Tmux deploy complete"
echo ""
echo "Open tmux and press: prefix + Shift + I"
echo "to install plugins via TPM"
