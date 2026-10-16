# Display Configuration (X11)

This module manages **monitor layout, refresh rate, and wallpaper setup** for X11 sessions.

The goal is to keep all display logic:

- explicit
- deterministic
- portable across locations (home, school, laptop-only, events)
- independent of the window manager

All configuration is applied at **X session startup** via `conf.d`.

It is also included in the session resync script, so layouts can be re-applied manually when monitors change.

---

## Scope

This module handles:

- multi-monitor layouts
- portrait and landscape rotation
- mixed refresh rates
- primary display selection
- laptop-only fallback behavior
- optional HDMI clone behavior
- root window wallpaper

It intentionally avoids:

- compositors
- GPU-specific configuration
- WM-specific logic
- hotplug daemons

---

## Installation

```bash
./install.sh
````

---

## How It Works

The display script is installed to:

```text
~/.config/system/display/monitor-setup.sh
```

A session hook is created:

```text
~/.config/x11/conf.d/display.sh
```

At session start, the window manager loads all scripts in:

```text
~/.config/x11/conf.d/
```

This ensures display configuration is applied **before the WM fully initializes**.

---

## Deterministic Rebuild Strategy

Before applying layout, the script disables all connected outputs:

```sh
xrandr | grep " connected" | cut -d' ' -f1 | while read -r output; do
    xrandr --output "$output" --off
done
```

The layout is then rebuilt from a clean state.

This avoids:

* unintended mirroring
* stale rotation settings
* cached resolutions
* inconsistent monitor ordering

Behavior remains consistent across:

* sleep / wake
* unplug / replug
* docking changes
* switching environments

---

## Environment Detection

The script uses simple detection:

* **Home setup** → specific outputs (e.g. DP-0, DP-2)
* **Fallback** → enable all connected outputs

This provides:

* deterministic behavior at home
* safe behavior elsewhere

---

## Dependencies

```bash
sudo pacman -S xorg-xrandr feh
```

* `xrandr` → display configuration
* `feh` → wallpaper

If `feh` is missing, wallpaper will not be applied.

---

## Wallpaper

Wallpaper is applied inside the display script:

```sh
WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"
feh --bg-fill "$WALLPAPER_DIR/default.png"
```

Notes:

* absolute paths are required
* `feh` exits after setting wallpaper (expected behavior)

---

## Resync Support

The script is also added to:

```text
~/.local/bin/resync-session
```

This allows manual reapplication:

* after monitor changes
* after sleep/wake
* when switching environments

---

## Script Source

Repository location:

```text
x11/shared/display/monitor-setup.sh
```

Installed to:

```text
~/.config/system/display/monitor-setup.sh
```

---

## Troubleshooting

Check outputs:

```bash
xrandr
xrandr --listmonitors
```

Check wallpaper:

```bash
xprop -root | grep -E 'ROOTPMAP|XROOTPMAP'
```

Common issues:

* missing `feh`
* incorrect wallpaper path
* incorrect output names
* conflicting layout commands

---

## Philosophy

Display configuration should be:

* simple
* predictable
* rebuilt from a clean state
* environment-aware

This module avoids dynamic behavior in favor of **explicit control and reproducibility**.
