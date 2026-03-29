# Lazy Git (TUI tool very nice to have)
```bash
sudo pacman -S lazygit
```
Git difftool config

# NOTE NVIM MUST BE INSTALLED FOR THIS TO WORK
git config --global diff.tool nvimdiff
git config --global difftool.prompt false


# THEN USE
git difftool


# Navigation inside vimdiff
]c  → next change
[c  → previous change
do  → diff obtain
dp  → diff put
:q  → quit
