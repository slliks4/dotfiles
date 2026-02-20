# Display Configuration (X11)

This module manages **monitor layout, refresh rate, and wallpaper setup** for X11 sessions.

The goal is to keep all display logic:

* explicit
* deterministic
* portable across locations (home, school, laptop-only, events)
* independent of the window manager

All configuration is applied at **X session startup**, before the WM launches.

It is also included in the session resync script, so layouts can be re-applied manually when monitors change.

---

## What This Module Handles

* Multi-monitor layouts
* Portrait and landscape rotation
* Mixed refresh rates
* Primary display selection
* Laptop-only fallback behavior
* Event / HDMI-only behavior
* Root window wallpaper

It intentionally avoids:

* compositors
* GPU-specific hacks
* WM-specific logic
* monitor hotplug daemons

---

## Deterministic Rebuild Strategy

Before applying any layout, the script explicitly disables all known outputs:

```sh
xrandr --output HDMI-1 --off 2>/dev/null || true
xrandr --output DP-1 --off 2>/dev/null || true
xrandr --output eDP-1 --off 2>/dev/null || true
```

This clears any hotplug auto-configuration performed by X.

By rebuilding the monitor layout from a clean state, the script avoids:

* unintended mirroring
* stale rotation settings
* cached resolutions
* inconsistent monitor ordering in dwm

The layout is always constructed from scratch.

This makes behavior fully deterministic across:

* sleep / wake
* unplug / replug
* docking changes
* switching between home and event setups

---

## Dependencies

This module assumes the following packages are installed:

```bash
sudo pacman -S xorg-xrandr feh
```

> ⚠️ If `feh` is not installed, wallpaper commands will fail silently.
> This is the most common cause of “wallpaper not working”.

---

## Script Location

Source of truth in the dotfiles repository:

```text
system/display/monitor-setup.sh
```

Installed via symlink to:

```text
~/.config/system/display/monitor-setup.sh
```

---

## How It Is Activated

The display script is executed from `~/.xinitrc`:

```sh
# Display setup
"$HOME/.config/system/display/monitor-setup.sh"

exec dwm
```

> ⚠️ `exec dwm` must be the last line in `.xinitrc`.
> Anything after it will never execute.

The script is also injected into:

```text
~/.local/bin/resync-session
```

This allows you to manually reapply monitor layout when:

* unplugging / replugging displays
* waking from sleep
* switching between docked and laptop-only modes

See: **system/session/resync**

---

## Why Explicit Coordinates Are Used

When mixing:

* rotated displays (portrait)
* high refresh-rate monitors
* laptops + externals

Relative placement (`--left-of`, `--right-of`) becomes unreliable.

This setup uses explicit `--pos` coordinates to:

* avoid overlap
* eliminate ambiguity
* ensure consistent geometry every startup

Explicit positioning guarantees predictable layout.

---

## Wallpaper Handling

Wallpaper is applied inside `monitor-setup.sh`:

```sh
WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"
feh --bg-fill "$WALLPAPER_DIR/default.png"
```

Notes:

* Absolute paths are required
* `feh` exits immediately after setting the root pixmap (this is normal)
* `pgrep feh` will usually return nothing

---

## Portability Notes

* Output names (`eDP-1`, `DP-1`, `HDMI-1`) are explicitly targeted
* Conditional checks prevent unsafe layout application
* Laptop-only setups do not inherit external monitor logic
* Event setups (HDMI only) remain landscape and auto-resolution

---

## Troubleshooting

Check monitor geometry:

```bash
xrandr
xrandr --listmonitors
```

Verify wallpaper is set:

```bash
xprop -root | grep -E 'ROOTPMAP|XROOTPMAP'
```

Common causes of failure:

* `feh` not installed
* incorrect wallpaper path
* display script placed after `exec dwm`
* overlapping `--pos` coordinates

---

## Philosophy

Display configuration should be:

* boring
* predictable
* rebuilt from a clean state
* solved once

This module exists so display behavior remains explicit and controllable — without patches, daemons, or window manager modifications.
