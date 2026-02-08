# Alacritty Terminal

This module configures **Alacritty** as the primary terminal emulator.

The goal is a setup that is:
- minimal
- fast
- keyboard-first
- visually quiet

With a slight **retro aesthetic**.

---

## What This Config Does

- Enables transparency (no compositor tricks)
- Uses bitmap-style fonts (e.g. Terminus)
- Disables decorations and animations
- Keeps colors simple and readable
- Avoids ligatures and modern visual noise

---

## Installation

From the dotfiles root:

```sh
cd system/terminal/alacritty
./install.sh
````

This creates:

```text
~/.config/alacritty/alacritty.toml → dotfiles
```

---

## Font Notes

This config expects a bitmap-style font such as:

* Terminus
* Dina
* Gohu
* ProggyClean

If the font is missing, Alacritty will fall back gracefully.

---

## Philosophy

The terminal should:

* disappear visually
* respond instantly
* never fight the window manager

This module exists so the terminal feels solved and stays out of the way.
