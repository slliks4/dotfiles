# Notifications (dunst)

This module provides **lightweight desktop notifications** for X11 using `dunst`.

The goal is:

* minimal footprint
* WM-agnostic behavior
* no visual bloat
* reliable notifications for screenshots, system events, and apps

`dunst` is used instead of Wayland-specific tools (e.g. `mako`) and integrates cleanly with `dwm`.

---

## What This Module Handles

* system notifications
* screenshot confirmations
* application alerts
* background daemon startup

It intentionally avoids:

* complex theming
* animations
* heavy dependencies

---

## Dependencies

Required packages:

```bash
sudo pacman -S dunst libnotify
```

Notes:

* `dunst` → notification daemon
* `libnotify` → provides `notify-send` for testing

---

## Script Location

Source (tracked in dotfiles):

```text
system/notifications/dunst.sh
```

Installed via symlink to:

```text
~/.config/system/notifications/dunst.sh
~/.config/dunst/dunstrc
```

The script is started from `~/.xinitrc` before `dwm` launches.
*NOTE: dunstrc is the configuration for the notification

---

## How It Is Used

Added to `.xinitrc`:

```sh
# Notifications
"$HOME/.config/system/notifications/dunst.sh"
```

This ensures:

* notifications start once per X session
* no duplicate daemons
* WM-independent behavior

---

## Testing Notifications

After starting X11 (or restarting `dunst`):

```bash
notify-send "Test Notification" "Dunst is working"
```

Expected behavior:

* notification appears on screen
* no terminal output
* no errors

If nothing appears:

* confirm `dunst` is running
* verify `libnotify` is installed
* check `ps aux | grep dunst`

---

## Restarting dunst (Manual)

If needed during testing:

```bash
pkill dunst
dunst &
```

---

## Philosophy

Notifications should:

* exist when needed
* stay out of the way
* require zero maintenance

This module exists so notifications **just work** — nothing more.
