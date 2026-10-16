#!/usr/bin/env bash
set -e

# ==========================
# Resolve paths
# ==========================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NODE_HOME="$HOME/.local/share/node"
NODE_CURRENT="$NODE_HOME/current"

ZSH_CONF_DIR="$HOME/.config/zsh/conf.d"
NODE_ZSH_FILE="$ZSH_CONF_DIR/node.zsh"

# ==========================
# Ensure directories
# ==========================
mkdir -p "$NODE_HOME"
mkdir -p "$ZSH_CONF_DIR"

# ==========================
# Shell config
# ==========================
if [ ! -f "$NODE_ZSH_FILE" ]; then
    echo "Creating node shell config -> $NODE_ZSH_FILE"

    cat > "$NODE_ZSH_FILE" << 'EOF'
export PATH="$HOME/.local/share/node/current/bin:$PATH"
EOF

else
    echo "node shell config already exists"
fi

# ==========================
# Detect extracted node dir
# ==========================
NODE_DIR=$(find "$NODE_HOME" \
    -maxdepth 1 \
    -type d \
    -name "node-v*-linux-x64" \
    | sort -V \
    | tail -n 1)

if [ -z "$NODE_DIR" ]; then
    echo "No extracted Node.js directory found."
    echo
    echo "Example:"
    echo "  node-v22.15.0-linux-x64"
    exit 1
fi

# ==========================
# Create current symlink
# ==========================
ln -sfn "$NODE_DIR" "$NODE_CURRENT"

echo "Linked -> $NODE_CURRENT"
echo "Using  -> $(basename "$NODE_DIR")"

# ==========================
# Reload hint
# ==========================
echo
echo "Restart shell or run:"
echo "  source ~/.zshrc"
echo
echo "Verify:"
echo "  node -v"
echo "  npm -v"
