#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles/dev/tmux"
TMUX_CONF_SOURCE="$DOTFILES_DIR/.tmux.conf"
TMUX_CONF_TARGET="$HOME/.tmux.conf"
PLUGIN_DIR="$HOME/.tmux/plugins"

echo "Deploying tmux configuration..."

# Ensure directories
mkdir -p "$DOTFILES_DIR"
mkdir -p "$PLUGIN_DIR"

# 1. Create base .tmux.conf if missing
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

# 2. Symlink into home
echo "Linking .tmux.conf into home directory..."
ln -sf "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"

# 3. Install TPM
TPM_DIR="$PLUGIN_DIR/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "TPM already installed"
fi

# 4. Install core plugins
declare -A PLUGINS=(
  ["tmux-resurrect"]="https://github.com/tmux-plugins/tmux-resurrect"
  ["tmux-continuum"]="https://github.com/tmux-plugins/tmux-continuum"
)

for name in "${!PLUGINS[@]}"; do
  DIR="$PLUGIN_DIR/$name"
  URL="${PLUGINS[$name]}"

  if [ ! -d "$DIR" ]; then
    echo "Installing $name..."
    git clone "$URL" "$DIR"
  else
    echo "$name already installed"
  fi
done

# 5. Symlink custom `ts` script + ensure fzf is installed
echo "Linking ts in ~/.local/bin"

LOCAL_BIN="$HOME/.local/bin"
TS_SOURCE="$DOTFILES_DIR/ts"
TS_TARGET="$LOCAL_BIN/ts"

# Ensure ~/.local/bin exists
mkdir -p "$LOCAL_BIN"

# Check ts exists in module dir
if [ -f "$TS_SOURCE" ]; then
  chmod +x "$TS_SOURCE"
  ln -sf "$TS_SOURCE" "$TS_TARGET"
  echo "ts linked → $TS_TARGET"
else
  echo "ts script not found in $DOTFILES_DIR"
fi

# Ensure fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  echo "📦 fzf not found — installing..."
  sudo pacman -S --noconfirm fzf
else
  echo "fzf already installed"
fi

echo "Tmux deploy complete"
echo ""
echo "Open tmux and press:  prefix + Shift + I"
echo "   to finalize plugin installation via TPM"
