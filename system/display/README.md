# Display Configuration (X11)

This module manages **monitor layout, refresh rate, and wallpaper setup** for X11 sessions.

The goal is to keep all display logic:
- explicit
- deterministic
- portable across locations (home, school, laptop-only)
- independent of the window manager

All configuration is applied at **X session startup**, before the WM launches.

---

## What This Module Handles

- Multi-monitor layouts
- Portrait and landscape rotation
- Mixed refresh rates
- Primary display selection
- Laptop-only fallback behavior
- Root window wallpaper

It intentionally avoids:
- compositors
- GPU-specific hacks
- WM-specific logic

---

## Dependencies

This module assumes the following packages are installed:

```bash
sudo pacman -S xorg-xrandr feh
````

> ⚠️ **Important:**
> If `feh` is not installed, wallpaper commands will fail silently.
> This is the most common cause of “wallpaper not working”.

---

## Script Location

The canonical script lives in this repository:

```text
system/display/monitor-setup.sh
```

It is installed via symlink to:

```text
~/.config/system/display/monitor-setup.sh
```

This follows XDG conventions and keeps user-level scripts out of `$HOME`.

---

## How It Is Used

The display script is sourced from `~/.xinitrc`:

```sh
# Display setup
"$HOME/.config/system/display/monitor-setup.sh"

exec dwm
```

> ⚠️ **Order matters:**
> `exec dwm` **must be the last line** in `.xinitrc`.
> Any commands placed after it will never execute.

This ensures:

* displays are configured before the WM starts
* layouts are applied once per session
* the configuration remains WM-agnostic

---

## Why Explicit Coordinates Are Used

When mixing:

* rotated displays (portrait)
* high refresh-rate monitors
* laptops + externals

Xrandr relative placement (`--left-of`, `--right-of`) becomes unreliable.

This setup uses **explicit `--pos` coordinates** to:

* avoid overlap
* eliminate ambiguity
* ensure consistent geometry every startup

---

## Wallpaper Handling

Wallpaper is applied inside `monitor-setup.sh`:

```sh
WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"
feh --bg-fill "$WALLPAPER_DIR/default.png"
```

Notes:

* Absolute paths are required (no `./relative` paths)
* `feh` exits immediately after setting the root pixmap (this is normal)
* `pgrep feh` will usually return nothing

Future improvements (optional):

* wallpaper randomization
* per-host or per-monitor wallpaper scripts
* separate wallpaper module under `bin/`

---

## Portability Notes

* Output names (`eDP-1`, `DP-1`, `HDMI-1`) are used instead of generic rules
* Conditional checks ensure safe behavior when monitors are unplugged
* School or laptop-only setups will not inherit unwanted rotation

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
* wallpaper path incorrect
* display script placed after `exec dwm`
* overlapping `--pos` coordinates

---

## Philosophy

Display configuration should be:

* boring
* predictable
* solved once

This module exists so display issues never need revisiting.
