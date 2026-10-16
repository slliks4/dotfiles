# X11 — Base Setup

This module installs the **minimum X11 (Xorg) environment**.

It provides the display server only and does not configure any session behavior.

---

## Scope

- Xorg installation
- basic X utilities
- runtime directory preparation

This module does **not**:

- create `.xinitrc`
- start a session
- configure a window manager

Session setup is handled by window manager modules (i3, dwm).

---

## Installation

```bash
./install.sh
````

---

## What This Provides

* Xorg server
* `startx` (via `xorg-xinit`)
* basic display utilities

---

## Fonts

Fonts are managed separately:

```bash
shared/system/fonts/install.sh
```

Fonts may be required for proper rendering (e.g. dwm status, terminal text).

---

## Next Step

Install a window manager:

* `x11/dwm`
* `x11/i3`

These modules will:

* create `.xinitrc`
* start the session
* load modules from `conf.d`

---

## Sources

* Arch Wiki — Xorg
  [https://wiki.archlinux.org/title/Xorg](https://wiki.archlinux.org/title/Xorg)

* Arch Wiki — Xinit
  [https://wiki.archlinux.org/title/Xinit](https://wiki.archlinux.org/title/Xinit)
