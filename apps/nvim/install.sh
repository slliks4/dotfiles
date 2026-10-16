#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
    printf '%s\n' \
        "Usage: ./install.sh [--clean-data]" \
        "" \
        "Install this Neovim configuration." \
        "" \
        "  --clean-data  Back up Neovim's data directory after installation." \
        "                This disables old packages stored there without deleting them." \
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

    if path_exists "$candidate"; then
        candidate="${candidate}-$$"
    fi

    printf '%s' "$candidate"
}

stdpath() {
    local kind="$1"

    nvim --clean --headless \
        --cmd "lua io.write(vim.fn.stdpath('${kind}'))" \
        --cmd 'quitall' 2>/dev/null
}

CLEAN_DATA=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        --clean-data)
            CLEAN_DATA=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage >&2
            die "Unknown option: $1"
            ;;
    esac
    shift
done

command -v nvim >/dev/null 2>&1 ||
    die "Neovim is not installed. Install it, then run this script again."

if ! command -v rg >/dev/null 2>&1; then
    printf '%s\n' \
        "Note: ripgrep (rg) was not found." \
        "The config will still work, but :grep will use Neovim's default program."
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
NVIM_DIR="$(stdpath config)"
TIMESTAMP="$(date '+%Y%m%d-%H%M%S')"

[ -n "$NVIM_DIR" ] || die "Could not determine Neovim's config directory."
[ -f "$SCRIPT_DIR/init.lua" ] || die "init.lua was not found beside this script."

if path_exists "$NVIM_DIR"; then
    CURRENT_DIR="$(cd "$NVIM_DIR" 2>/dev/null && pwd -P || true)"
    if [ "$CURRENT_DIR" = "$SCRIPT_DIR" ]; then
        printf 'Already installed at %s\n' "$NVIM_DIR"
        exit 0
    fi
fi

NVIM_PARENT="$(dirname "$NVIM_DIR")"
mkdir -p "$NVIM_PARENT"

STAGE_ROOT="$(mktemp -d "$NVIM_PARENT/.nvim-install.XXXXXX")"
STAGED_NVIM="$STAGE_ROOT/config"
mkdir "$STAGED_NVIM"

cleanup() {
    rm -rf -- "$STAGE_ROOT"
}
trap cleanup EXIT HUP INT TERM

# Copy only files Neovim can use. Repository files such as .git and this
# installer are intentionally left out.
CONFIG_ITEMS=(
    "init.lua"
    "lua"
)

for item in "${CONFIG_ITEMS[@]}"; do
    if path_exists "$SCRIPT_DIR/$item"; then
        cp -R "$SCRIPT_DIR/$item" "$STAGED_NVIM/"
    fi
done

CONFIG_BACKUP=""
if path_exists "$NVIM_DIR"; then
    CONFIG_BACKUP="$(backup_name "$NVIM_DIR")"
    mv "$NVIM_DIR" "$CONFIG_BACKUP"
    printf 'Backed up existing config to %s\n' "$CONFIG_BACKUP"
fi

if ! mv "$STAGED_NVIM" "$NVIM_DIR"; then
    if [ -n "$CONFIG_BACKUP" ] && path_exists "$CONFIG_BACKUP"; then
        mv "$CONFIG_BACKUP" "$NVIM_DIR"
    fi
    die "Could not install the new config. The previous config was restored."
fi

# Loading the installed config from its real path lets local Lua modules resolve.
# --noplugin prevents unrelated old packages from affecting this check.
if ! nvim --headless --noplugin -i NONE '+quitall' </dev/null; then
    FAILED_CONFIG="${NVIM_DIR}.failed-${TIMESTAMP}"
    mv "$NVIM_DIR" "$FAILED_CONFIG"

    if [ -n "$CONFIG_BACKUP" ] && path_exists "$CONFIG_BACKUP"; then
        mv "$CONFIG_BACKUP" "$NVIM_DIR"
        printf 'The previous config was restored.\n' >&2
    fi

    die "The startup check failed. The new config is saved at $FAILED_CONFIG"
fi

if [ "$CLEAN_DATA" -eq 1 ]; then
    NVIM_DATA_DIR="$(stdpath data)"

    if path_exists "$NVIM_DATA_DIR"; then
        DATA_BACKUP="$(backup_name "$NVIM_DATA_DIR")"
        mv "$NVIM_DATA_DIR" "$DATA_BACKUP"
        printf 'Backed up existing Neovim data to %s\n' "$DATA_BACKUP"
    else
        printf 'No existing Neovim data directory was found.\n'
    fi
fi

printf '\nInstalled Neovim config at %s\n' "$NVIM_DIR"

if [ -f "$SCRIPT_DIR/nvim.shell" ]; then
    printf 'Optional shell settings are in %s\n' "$SCRIPT_DIR/nvim.shell"
else
    printf '%s\n' \
        "Optional shell settings:" \
        "  export EDITOR=nvim" \
        "  export VISUAL=nvim" \
        "  alias vi=nvim" \
        "  alias vim=nvim"
fi

printf 'Done. Open Neovim with: nvim\n'
