# Keyboard Configuration (X11)

This module configures **keyboard behavior at the X11 level**.

It is:

- window-manager agnostic
- applied once per X session
- safe to run repeatedly
- independent of desktop environments

---

## Scope

This module:

- sets key repeat rate
- maps **Caps Lock → Escape**
- maps **Shift + Caps Lock → Caps Lock**

This improves ergonomics for:

- terminal usage
- Vim-style workflows
- window manager keybindings

---

## Installation

```bash
./install.sh
````

---

## How It Works

The keyboard script is installed to:

```text
~/.config/system/keyboard/keyboard.sh
```

A session hook is created:

```text
~/.config/x11/conf.d/keyboard.sh
```

At session start, the window manager loads all scripts in:

```text
~/.config/x11/conf.d/
```

This ensures keyboard configuration is applied **after X starts**.

---

## Implementation

Uses X11 utilities:

* `xset` → key repeat rate
* `setxkbmap` → keyboard mapping

XKB option used:

```text
caps:escape_shifted_capslock
```

No daemons or background services are involved.

---

## Resync Support

The script is also added to:

```text
~/.local/bin/resync-session
```

This allows manual reapplication when needed.

See: `x11/shared/session/resync`

---

## Notes

* safe to re-run
* applied globally for the X session
* does not depend on a specific window manager

---

## Philosophy

Keyboard configuration should be:

* simple
* predictable
* global

This module ensures keyboard behavior is defined once and remains consistent.
