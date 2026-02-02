#!/usr/bin/env bash
set -e

THEME_DIR="/boot/grub/themes"
THEME_NAME="$(basename "$(pwd)")"
THEME_DEST="${THEME_DIR}/${THEME_NAME}"

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;36m"
RESET="\033[0m"

info()    { echo -e "${BLUE}[INFO]${RESET} $*"; }
success() { echo -e "${GREEN}[OK]${RESET} $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*"; exit 1; }

# Root check
[[ $EUID -ne 0 ]] && error "Run this script as root"

info "Installing GRUB theme: ${THEME_NAME}"

# Ensure theme directory exists
mkdir -p "${THEME_DIR}"

# Replace existing theme safely
rm -rf "${THEME_DEST}"
cp -r . "${THEME_DEST}"

# Backup grub config once
[[ ! -f /etc/default/grub.bak ]] && \
  cp /etc/default/grub /etc/default/grub.bak

# Set GRUB_THEME
sed -i '/^GRUB_THEME=/d' /etc/default/grub
echo "GRUB_THEME=\"${THEME_DEST}/theme.txt\"" >> /etc/default/grub

info "Regenerating GRUB config"
grub-mkconfig -o /boot/grub/grub.cfg

success "Theme '${THEME_NAME}' installed successfully"
