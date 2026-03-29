#!/usr/bin/env sh
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
GIT_CONFIG=".gitconfig"
TARGET="$BASE_DIR/$GIT_CONFIG"

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

ln -sf "$TARGET" "$HOME/.gitconfig"
