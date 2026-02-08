#!/usr/bin/env sh
set -e

# --------------------------
# Paths
# --------------------------

# Absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Module paths
DOTFILES_DIR="$SCRIPT_DIR"
BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="screenshot"

TARGET_SCRIPT="$BIN_DIR/$SCRIPT_NAME"

# --------------------------
# Dependency checks
# (binary → package)
# --------------------------
check_dep() {
  command -v "$1" >/dev/null 2>&1
}

install_pkgs=""

check_dep maim        || install_pkgs="$install_pkgs maim"
check_dep slop        || install_pkgs="$install_pkgs slop"
check_dep xclip       || install_pkgs="$install_pkgs xclip"
check_dep notify-send || install_pkgs="$install_pkgs libnotify"
check_dep python3     || install_pkgs="$install_pkgs python"

if [ -n "$install_pkgs" ]; then
  echo "📦 Installing missing dependencies:$install_pkgs"
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
echo "✅ Screenshot utility installed"
echo "→ $TARGET_SCRIPT"
