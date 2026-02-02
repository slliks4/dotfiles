# Application Menu

This module provides a **simple, keyboard-driven application menu** for X11.

It is used for:
- launching applications
- browsing available commands
- running small user scripts

The menu is intentionally kept:
- minimal
- fast
- WM-agnostic
- script-friendly

---

## Design Goals

- no background services
- no heavy UI dependencies
- predictable behavior
- easy replacement (e.g. `dmenu` → `rofi`)

The window manager only **invokes** the menu.
All menu logic lives here.

---

## Implementation

The initial implementation uses:

- `dmenu`
sudo pacman -S dmenu

This aligns with the minimal X11 + dwm workflow and avoids premature complexity.

---

## Usage

The menu is typically triggered via a window-manager keybinding
(e.g. `Mod + space` in dwm).

What the menu launches and how it behaves
is defined entirely within this module.

---

## Philosophy

Launching applications should be:
- fast
- quiet
- forgettable

This module exists so menus stay simple
and do not dictate how the rest of the system is built.
