# wiki-tui helper

This module installs and configures **wiki-tui** on **Arch Linux**.

It is a small developer convenience tool and lives under `dev/`,
not the system layer.

---

## What This Tool Does

- Installs `wiki-tui` via `pacman`
- Adds a shell alias for quick access
- Avoids manual post-install steps

---

## Requirements

- Arch Linux
- `pacman`
- `sudo`
- `zsh` (for alias configuration)

---

## Installation

From the dotfiles root:

```sh
cd dev/wiki-tui
./install.sh
````

This will:

* install `wiki-tui` if missing
* append the following to `.zshrc`:

```text
alias wiki="wiki-tui"
```

---

## Usage

Open Wikipedia from the terminal:

```sh
wiki
```

Navigation and search are fully keyboard-driven.

---

## Philosophy

This tool exists to:

* reduce friction
* keep dotfiles declarative
* automate boring setup
* stay minimal

It does not manage:

* shell configuration beyond a single alias
* keybindings
* terminal appearance

Those concerns belong elsewhere.
