# Keyboard Configuration (X11)

This module configures **keyboard behavior at the X11 level**.

It is:

* window-manager agnostic
* applied once per X session
* safe to run repeatedly
* independent of desktop environments

---

## What This Module Does

* Maps **Caps Lock → Escape**
* Maps **Shift + Caps Lock → Caps Lock**

This improves ergonomics for:

* terminal usage
* Vim-style workflows
* window manager keybindings

Without losing access to Caps Lock when needed.

---

## How It Works

Uses the XKB option:

```text
caps:escape_shifted_capslock
```

Applied via:

```sh
setxkbmap
```

No daemons, services, or patches are involved.

---

## Usage

The configuration is applied by sourcing the script from `.xinitrc`:

```sh
"$HOME/.config/system/keyboard/keyboard.sh"
```

It is also included in the session resync script, so it can be re-applied manually if needed.

See: **system/session/resync**

---

## Philosophy

Keyboard configuration should be:

* simple
* predictable
* global

This module exists so Caps Lock behavior is solved once and never revisited.
