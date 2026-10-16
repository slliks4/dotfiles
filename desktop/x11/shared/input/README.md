# Input Configuration (X11)

This module configures **trackpad behavior** for X11 sessions.

It exists to fix common defaults that are unintuitive on laptops, such as:

- inverted scrolling
- disabled tap-to-click
- inconsistent pointer behavior across sessions

The configuration is applied at **X session startup** via `conf.d`.

It is also included in the session resync script, so settings can be re-applied manually if needed.

---

## Scope

This module:

- enables natural scrolling
- enables tap-to-click
- applies click method configuration
- ensures consistent behavior across sessions

It is:

- window-manager agnostic
- optional (primarily for laptops)
- safe to run repeatedly

---

## Installation

```bash
./install.sh
````

---

## How It Works

The trackpad script is installed to:

```text
~/.config/system/input/trackpad.sh
```

A session hook is created:

```text
~/.config/x11/conf.d/input.sh
```

At session start, the window manager loads all scripts in:

```text
~/.config/x11/conf.d/
```

This ensures input configuration is applied **after X starts**.

---

## Implementation

Uses:

* `xinput` → device configuration
* `libinput` → driver-level properties

Settings are applied dynamically to the detected trackpad device.

If no trackpad is found, the script exits safely.

---

## Resync Support

The script is also added to:

```text
~/.local/bin/resync-session
```

This allows manual reapplication when:

* waking from sleep
* docking / undocking
* input behavior becomes inconsistent

See: `x11/shared/session/resync`

---

## Dependencies

```bash
sudo pacman -S xorg-xinput
```

Handled automatically by `install.sh`.

---

## Notes

* safe to re-run
* does nothing on systems without a trackpad
* does not affect external mouse devices

---

## Philosophy

Input configuration should be:

* simple
* predictable
* applied once per session

This module ensures trackpad behavior remains consistent without relying on daemons or desktop environments.
