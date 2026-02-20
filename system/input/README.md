# Trackpad Configuration (X11)

This module configures **trackpad behavior** for X11 sessions.

It exists to fix common defaults that are unintuitive on laptops, such as:

* inverted scrolling
* disabled tap-to-click
* inconsistent pointer behavior across sessions

The configuration is applied at **X session startup**, before the window manager launches.

It is also included in the session resync script, so settings can be re-applied manually if needed.

---

## What This Module Does

* enables natural (non-inverted) scrolling
* enables tap-to-click
* applies settings consistently across reboots
* remains window-manager agnostic

All settings are applied using `xinput` and `libinput`.

No daemons.
No desktop environment integration.

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

It is also injected into:

```text
~/.local/bin/resync-session
```

So it can be re-run manually when:

* waking from sleep
* reconnecting displays
* input state behaves unexpectedly

See: **system/session/resync**

---

## Dependencies

Required package:

```bash
sudo pacman -S xorg-xinput
```

Handled automatically by `install.sh`.

---

## Philosophy

Trackpad behavior should be:

* boring
* predictable
* identical every login

This module exists so input quirks are solved once and never revisited.
