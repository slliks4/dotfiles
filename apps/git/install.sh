
#!/usr/bin/env bash
set -Eeuo pipefail

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

path_exists() {
    [ -e "$1" ] || [ -L "$1" ]
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE="$SCRIPT_DIR/.gitconfig"
TARGET="$HOME/.gitconfig"

# Dependencies
command -v git >/dev/null 2>&1 ||
    die "Git is not installed. Install it and try again."

if ! command -v gh >/dev/null 2>&1; then
    printf '%s\n' "Note: GitHub CLI (gh) is missing. GitHub credential integration requires it."
fi

[ -f "$SOURCE" ] ||
    die ".gitconfig was not found beside this script."

# Skip if already installed
if [ -f "$TARGET" ] && [ ! -L "$TARGET" ] &&
    cmp -s "$SOURCE" "$TARGET"; then
    printf 'Git configuration already installed.\n'
    exit 0
fi

# Stage the new configuration
STAGED="$(mktemp "$HOME/.gitconfig.tmp.XXXXXX")"
trap 'rm -f -- "$STAGED"' EXIT

cp "$SOURCE" "$STAGED"

# Back up existing configuration
BACKUP=""
if path_exists "$TARGET"; then
    BACKUP="${TARGET}.bak-$(date '+%Y%m%d-%H%M%S')-$$"
    mv "$TARGET" "$BACKUP"
    printf 'Backed up existing config to %s\n' "$BACKUP"
fi

# Install configuration
if ! mv "$STAGED" "$TARGET"; then
    if [ -n "$BACKUP" ]; then
        mv "$BACKUP" "$TARGET" ||
            die "Installation failed and backup restoration failed."
    fi
    die "Could not install Git configuration."
fi

printf 'Git configuration installed at %s\n' "$TARGET"
printf 'Done.\n'
