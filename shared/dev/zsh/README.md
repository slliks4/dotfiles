# Zsh — Shell Environment

This module configures the **interactive shell environment** using `zsh`.

It defines the **core runtime behavior** for terminal workflows.

---

## Scope

This module is:

- user-level
- environment-defining
- window-manager agnostic
- independent of display (X11 / Wayland)
- safe to re-run

It applies to:
- login shells
- interactive shells
- tmux sessions

---

## What This Module Does

- installs `zsh`
- sets `zsh` as the default shell
- installs **Oh My Zsh**
- links a managed `.zshrc`
- defines environment variables and PATH
- enables a minimal plugin set
- configures a lightweight prompt and interaction model

---

## Configuration Highlights

### Environment

- ensures `$HOME/.local/bin` is in PATH
- sets editor (`nvim` locally, `vim` over SSH)
- enables project-local Python environments

---

### Interaction Model

- Vim-style keybindings (`bindkey -v`)
- fast mode switching (`jj` → NORMAL)
- cursor shape reflects mode (INSERT vs NORMAL)

---

### Prompt

- minimal, dynamic prompt
- shows:
  - current mode (INSERT / NORMAL)
  - working directory
  - git branch + status

No theme frameworks are used.

---

### Plugins

- `git`
- `fast-syntax-highlighting`

Plugins are kept minimal to preserve performance.

---

## Usage

```bash
cd shared/dev/zsh
./install.sh
````

Then:

```bash
exec zsh
```

or log out and back in.

---

## Notes

* this module defines the shell environment for the entire system
* UI customization is minimal and controlled
* additional tooling (nvim, fzf, etc.) is handled in separate modules

---

## Philosophy

The shell should be:

* predictable
* fast
* minimal at the core
* expressive without heavy frameworks
