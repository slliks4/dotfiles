# Status Bar (dwm)

This module provides a **minimal status bar for dwm** using `xsetroot`.

It is intentionally:

- simple
- low-noise
- dependency-light
- easy to extend

The status bar is implemented as a small shell script running in the background.

---

## What It Shows

Right-aligned status information:

- **Network**
  - `ETH` when wired
  - `WIFI` when connected
  - `OFF` when disconnected

- **CPU usage**
  - smoothed average (stable, not jumpy)

- **Memory usage**
  - used / total RAM

- **Battery**
  - percentage + charging state (if available)

- **Date & time**

- **Volume**

- **Brightness**

The values are designed to be:

- readable at a glance
- stable (no flickering)
- useful outside tmux

---

## Script Location

Source (dotfiles):

```text
system/status/status.sh
````

Installed to:

```text
~/.config/system/status/status.sh
```

---

## How It Works

* runs in a loop
* updates the X root window using `xsetroot`
* refresh interval is conservative
* values are smoothed where necessary

---

## Dependencies

Required:

```bash
sudo pacman -S xorg-xsetroot
```

Common tools used:

* `iproute2`
* `procps`
* `coreutils`
* `acpi` (optional, for battery)

---

## Startup Model

The script is launched through the shared X11 system:

```text
~/.config/x11/conf.d/status.sh
```

The hook ensures it only runs under dwm:

```sh
[ "$WM" = "dwm" ] || exit 0
```

The main script is then started in the background.

---

## Integration with X11

Startup flow:

```text
~/.xinitrc
  → loads ~/.config/x11/conf.d/*
  → exports WM=dwm or WM=i3
  → exec dwm / exec i3
```

This means:

* shared setup runs for all window managers
* dwm-specific behavior is conditionally enabled

---

## Design Notes

* no dwm patches required
* no external bar (polybar, etc.)
* no compositor dependency
* no GPU requirements

The bar is:

* portable
* predictable
* easy to debug

---

## Notes

* only active when running dwm
* does not interfere with i3 or other window managers
* safe to run alongside shared `conf.d` scripts

---

## Philosophy

The status bar should:

* stay out of the way
* show only useful information
* remain stable and predictable

This implementation follows that approach.
