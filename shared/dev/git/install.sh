#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

GIT_CONFIG=".gitconfig"
TARGET="$SCRIPT_DIR/$GIT_CONFIG"

# ==========================
# Dependencies
# ==========================
ensure_pkg() {
    if ! pacman -Qi "$1" >/dev/null 2>&1; then
        echo "Installing missing dependency: $1"
        sudo pacman -S --noconfirm "$1"
    fi
}

ensure_pkg less
ensure_pkg git
ensure_pkg man-db
ensure_pkg man-pages
ensure_pkg github-cli   # for gh credential helper

# Create config if missing
if [ ! -f "$TARGET" ]; then
cat > "$TARGET" <<'EOF'
[credential "https://github.com"]
    helper =
    helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
    helper =
    helper = !/usr/bin/gh auth git-credential
[init]
    defaultBranch = main
EOF
fi

# Link into home
ln -sf "$TARGET" "$HOME/.gitconfig"

echo "Git configured"
