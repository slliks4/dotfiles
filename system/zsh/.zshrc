# -------------------------
# Oh My Zsh (NO THEME)
# -------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# -------------------------
# Environment
# -------------------------
export PIPENV_VENV_IN_PROJECT=1
export PATH="$HOME/.local/bin:$PATH"

# -------------------------
# Plugins
# -------------------------
plugins=(git fast-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# -------------------------
# Clean LS_COLORS (no background highlights)
# -------------------------
LS_COLORS="di=38;5;71:ln=36:so=35:pi=33:ex=32:bd=33:cd=33:su=31:sg=33:tw=30:ow=34"
export LS_COLORS

# -------------------------
# Vim Mode
# -------------------------
bindkey -v
KEYTIMEOUT=1

bindkey -M viins 'jj' vi-cmd-mode
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# -------------------------
# Enable dynamic prompt
# -------------------------
setopt PROMPT_SUBST

# -------------------------
# Mode state (visible badge)
# -------------------------
CURRENT_MODE="%K{238}%F{71}  INSERT  %f%k"

# -------------------------
# Cursor + Mode switching
# -------------------------
function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
        CURRENT_MODE="%K{238}%F{167}  NORMAL  %f%k"
        echo -ne '\e[1 q'   # block cursor
    else
        CURRENT_MODE="%K{238}%F{71}  INSERT  %f%k"
        echo -ne '\e[5 q'   # beam cursor
    fi
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init {
    zle-keymap-select
}
zle -N zle-line-init

# -------------------------
# Colors
# -------------------------
autoload -U colors && colors

# -------------------------
# Git prompt tuning
# -------------------------
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_BRANCH="%F{180}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{167}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{71}✓"

# -------------------------
# Prompt
# -------------------------
PROMPT='${CURRENT_MODE} %F{71}%~ %F{180}$(git_prompt_info)%f '
PROMPT2='%F{178}➜ %f'

# -------------------------
# Editor
# -------------------------
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# -------------------------
# Aliases
# -------------------------
alias vim=nvim
alias vi=nvim
alias py=python
alias pdf="zathura"
alias wiki="wiki-tui"

# -------------------------
# Lazy-load NVM (FAST)
# -------------------------
export NVM_DIR="$HOME/.nvm"

nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm "$@"
}

# -------------------------
# Lazy-load pyenv (FAST)
# -------------------------
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
    unset -f pyenv
    eval "$(command pyenv init -)"
    pyenv "$@"
}

# -------------------------
# Custom scripts
# -------------------------
source "/home/scaramouche/.dotfiles/dev/python/shell-guards.zsh"

# -------------------------
# Misc
# -------------------------
export KATTIS_DIR="$HOME/kattis"
