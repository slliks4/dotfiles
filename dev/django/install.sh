#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="dj"

SRC="$SCRIPT_DIR/$SCRIPT_NAME"
TARGET="$BIN_DIR/$SCRIPT_NAME"

# --------------------------
# Dependency check
# --------------------------

if ! command -v python >/dev/null 2>&1; then
  echo "❌ python not found"
  echo "   Install Python before using dj"
  exit 1
fi

# --------------------------
# Install
# --------------------------

mkdir -p "$BIN_DIR"

if [ -L "$TARGET" ] || [ -f "$TARGET" ]; then
  rm -f "$TARGET"
fi

ln -s "$SRC" "$TARGET"
chmod +x "$SRC"

echo "✔ dj installed to $BIN_DIR"
echo "You can now run: dj start <ProjectName>"
