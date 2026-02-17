#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

DOTFILES_DIR="$SCRIPT_DIR"
BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="toggle-night"

TARGET_SCRIPT="$BIN_DIR/$SCRIPT_NAME"

# --------------------------
# Dependency checks
# (binary → package)
# --------------------------
check_dep() {
  command -v "$1" >/dev/null 2>&1
}

install_pkgs=""

check_dep redshift || install_pkgs="$install_pkgs redshift"

if [ -n "$install_pkgs" ]; then
  echo "Installing missing dependencies:$install_pkgs"
  sudo pacman -S --needed $install_pkgs
fi

# --------------------------
# Create bin directory
# --------------------------
mkdir -p "$BIN_DIR"

# --------------------------
# Symlink script
# --------------------------
chmod +x "$DOTFILES_DIR/$SCRIPT_NAME"
ln -sf "$DOTFILES_DIR/$SCRIPT_NAME" "$TARGET_SCRIPT"

# --------------------------
# Done
# --------------------------
echo "Night light toggle installed"
echo "→ $TARGET_SCRIPT"
