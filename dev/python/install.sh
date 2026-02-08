#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/shell-guards.zsh"
ZSHRC="$HOME/.zshrc"

if ! command -v python >/dev/null 2>&1; then
  echo "❌ python not found; skipping python shell guards"
  exit 0
fi

if ! grep -q "shell-guards.zsh" "$ZSHRC"; then
  echo "" >> "$ZSHRC"
  echo "# Python shell safety" >> "$ZSHRC"
  echo "source \"$SRC\"" >> "$ZSHRC"
  echo "✔ Python shell guards enabled"
else
  echo "ℹ Python shell guards already present"
fi
