#!/usr/bin/env bash
set -e

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg grub
ensure_pkg efibootmgr
ensure_pkg os-prober

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;36m"
RESET="\033[0m"

info()  { echo -e "${BLUE}[INFO]${RESET} $*"; }
error() { echo -e "${RED}[ERROR]${RESET} $*"; exit 1; }

# Root check
if [[ $EUID -ne 0 ]]; then
  info "Re-running installer with sudo..."
  exec sudo "$0"
fi

[[ -d "$THEMES_DIR" ]] || error "Themes directory not found: $THEMES_DIR"

mapfile -t THEMES < <(
  find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d \
  -exec test -f "{}/install.sh" \; -print \
  | sort
)

[[ ${#THEMES[@]} -gt 0 ]] || error "No themes found"

echo
info "Available GRUB themes:"
echo

for i in "${!THEMES[@]}"; do
  echo "  [$((i+1))] $(basename "${THEMES[$i]}")"
done

echo
read -rp "Select a theme number: " CHOICE
[[ -n "$CHOICE" ]] || error "No selection made"
[[ "$CHOICE" =~ ^[0-9]+$ ]] || error "Invalid selection"
(( CHOICE >= 1 && CHOICE <= ${#THEMES[@]} )) || error "Selection out of range"

SELECTED="${THEMES[$((CHOICE-1))]}"

info "Installing theme: $(basename "$SELECTED")"
cd "$SELECTED" || error "Failed to enter theme directory"

./install.sh

info "Done."
