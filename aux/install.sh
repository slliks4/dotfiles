#!/usr/bin/env bash
set -Eeuo pipefail

# Installs / refreshes all "aux" (everyday) apps in this repo.
# Run from anywhere:
#   ~/.dotfiles/aux/install.sh
#
# This script is intentionally simple:
# - each app has its own deploy.sh
# - this script just calls them in order

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
AUX_DIR="$DOTFILES_DIR/aux"

apps=(
  "discord"
)

echo "==> Aux installer"
echo "DOTFILES_DIR: $DOTFILES_DIR"
echo "AUX_DIR:      $AUX_DIR"
echo

for app in "${apps[@]}"; do
  deploy="$AUX_DIR/$app/deploy.sh"
  if [[ ! -x "$deploy" ]]; then
    echo "!! Skipping '$app' (missing or not executable): $deploy"
    continue
  fi

  echo "==> Deploying: $app"
  "$deploy"
  echo
done

echo "==> Done."
