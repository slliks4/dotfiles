
#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
    printf '%s\n' \
        "Usage: ./install.sh" \
        "" \
        "Install tmux configuration, TPM, and helper scripts." \
        "" \
        "  -h, --help    Show this help."
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

path_exists() {
    [ -e "$1" ] || [ -L "$1" ]
}

backup_name() {
    local path="$1"
    local candidate="${path}.bak-${TIMESTAMP}"
    local count=1

    while path_exists "$candidate"; do
        candidate="${path}.bak-${TIMESTAMP}-${count}"
        ((count += 1))
    done

    printf '%s' "$candidate"
}

install_file() {
    local source="$1"
    local target="$2"
    local mode="$3"
    local backup=""
    local staged

    # Nothing to replace if contents are identical.
    if [ -f "$target" ] && [ ! -L "$target" ] &&
        cmp -s "$source" "$target"; then
        chmod "$mode" "$target"
        printf 'Already installed: %s\n' "$target"
        return
    fi

    mkdir -p "$(dirname "$target")"

    # Prepare the replacement before touching the original.
    staged="$(mktemp "${target}.tmp.XXXXXX")"
    cp "$source" "$staged"
    chmod "$mode" "$staged"

    if path_exists "$target"; then
        backup="$(backup_name "$target")"
        mv "$target" "$backup"
        printf 'Backed up %s to %s\n' "$target" "$backup"
    fi

    if ! mv "$staged" "$target"; then
        rm -f "$staged"

        if [ -n "$backup" ]; then
            mv "$backup" "$target" ||
                die "Installation failed and backup restoration failed: $backup"
        fi

        die "Could not install $target"
    fi

    printf 'Installed: %s\n' "$target"
}

for arg in "$@"; do
    case "$arg" in
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            die "Unknown option: $arg"
            ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

TMUX_SOURCE="$SCRIPT_DIR/.tmux.conf"
TMUX_TARGET="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"
LOCAL_BIN="$HOME/.local/bin"

# Dependencies
for cmd in tmux git; do
    command -v "$cmd" >/dev/null 2>&1 ||
        die "$cmd is not installed. Install it and run this script again."
done

if ! command -v fzf >/dev/null 2>&1; then
    printf '%s\n' \
        "Note: fzf is not installed." \
        "Some tmux bindings or helper scripts may require it."
fi

[ -f "$TMUX_SOURCE" ] ||
    die ".tmux.conf was not found beside this script."

# Install TPM without modifying an existing installation.
if [ ! -d "$TPM_DIR" ]; then
    printf 'Installing TPM...\n'
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$TPM_DIR"
elif [ ! -f "$TPM_DIR/tpm" ]; then
    die "$TPM_DIR exists but does not look like a TPM installation."
else
    printf 'TPM already installed.\n'
fi

# Install configuration.
install_file "$TMUX_SOURCE" "$TMUX_TARGET" 644

# Install optional helper scripts.
for script in ts ts-dev; do
    source="$SCRIPT_DIR/$script"
    target="$LOCAL_BIN/$script"

    if [ -f "$source" ]; then
        install_file "$source" "$target" 755
    else
        printf 'Skipping missing helper: %s\n' "$script"
    fi
done

printf '\nTmux installation complete.\n'
printf 'Open tmux and press prefix + I to install plugins.\n'
printf 'Ensure %s is in your PATH for the helper scripts.\n' "$LOCAL_BIN"
