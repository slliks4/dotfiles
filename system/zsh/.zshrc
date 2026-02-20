# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# Environment
export PIPENV_VENV_IN_PROJECT=1
export PATH="$HOME/.local/bin:$PATH"

# Plugins
plugins=(git fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Vim mode
bindkey -v
KEYTIMEOUT=1
bindkey -M viins 'jj' vi-cmd-mode
bindkey '^k' up-line-or-search
bindkey '^j' down-line-or-search

# Cursor shape
function zle-keymap-select {
    [[ $KEYMAP == vicmd ]] && echo -ne '\e[1 q' || echo -ne '\e[5 q'
}
zle -N zle-keymap-select
echo -ne '\e[5 q'

# Editor
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Aliases
alias vim=nvim
alias vi=nvim
alias py=python

# NOTE: FROM DOWN BELOW ARE ADDED BY THEIR INDIVIDUAL SCRIPTS
# NVM (once)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# PDF viewer
alias pdf="zathura"

# Python shell safety
source "/home/scaramouche/.dotfiles/dev/python/shell-guards.zsh"

# wiki-tui
alias wiki="wiki-tui"
