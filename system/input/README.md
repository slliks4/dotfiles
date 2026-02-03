# Trackpad Configuration (X11)

This module configures **trackpad behavior** for X11 sessions.

It exists to fix common defaults that are unintuitive on laptops, such as:

* inverted scrolling
* disabled tap-to-click
* inconsistent pointer behavior across sessions

The configuration is applied at **X session startup**, before the window manager launches.

---

## What This Module Does

* enables natural (non-inverted) scrolling
* enables tap-to-click
* applies settings consistently across reboots
* remains window-manager agnostic

All settings are applied using `xinput` and `libinput`.

---

## Script Location

Source of truth in the dotfiles repository:

```text
system/input/trackpad.sh
```

Installed via symlink to:

```text
~/.config/system/input/trackpad.sh
```

---

## How It Is Activated

The script is executed from `~/.xinitrc`:

```sh
# Trackpad setup
"$HOME/.config/system/input/trackpad.sh"
```

This ensures:

* settings apply once per X session
* behavior is predictable
* no per-application hacks are needed

---

## Dependencies

Required package:

```bash
sudo pacman -S xorg-xinput
```

This is handled automatically by `install.sh`.

---

## Philosophy

Trackpad behavior should be:

* boring
* predictable
* identical every login

This module exists so input quirks never need revisiting.
