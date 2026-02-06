# Status Bar (dwm)

This module provides a **minimal, WM-agnostic status bar** for `dwm` using
`xsetroot`.

It is intentionally:

* simple
* low-noise
* dependency-light
* easy to extend later

The status bar is updated by a small shell script running in the background.

---

## What It Shows (Current)

Right-aligned status information:

* **Network**

  * `ETH` when wired
  * `WIFI` when connected via wireless
  * `OFF` when disconnected

* **CPU usage**

  * Smoothed average usage (not jumpy)

* **Memory usage**

  * Used / total RAM

* **Battery status**

  * Percentage + charging/discharging state (if present)

* **Date & time**

* **Volume**

* **Brightness**

The values are designed to be:

* readable at a glance
* stable (no rapid flickering)
* useful outside of tmux (reading, meetings, browsing)

---

## Script Location

Source script in dotfiles:

```text
system/status/status.sh
```

Installed via symlink to:

```text
~/.config/system/status/status.sh
```

This keeps system scripts:

* version-controlled
* reusable
* independent of dwm source code

---

## How It Works

* Runs in an infinite loop
* Updates the X root window using `xsetroot`
* Refresh interval is intentionally conservative
* CPU and memory values are averaged (not per-second spikes)

This avoids noisy or distracting updates.

---

## Dependencies

Required:

```bash
sudo pacman -S xorg-xsetroot
```

Optional but commonly present:

* `iproute2`
* `procps`
* `coreutils`
* `acpi` (for battery)

The script performs basic dependency checks.

---

## Startup Integration

The status script is launched from `~/.xinitrc` **before** `dwm` starts:

```sh
# Status bar
"$HOME/.config/system/status/status.sh" &
```

Running it in the background is required — the script never exits.

---

## Design Notes

* No dwm patches required
* No external bar (polybar, xmobar, etc.)
* No compositor assumptions
* No GPU dependencies

This keeps the bar:

* portable
* predictable
* trivial to debug

---

## Future Extensions (Optional)

This module can later be extended with:

* color accents per state
* icons (ASCII or Nerd Font)
* disk usage
* temperature
* notifications hook

None of these are required for daily use.

---

## Philosophy

The status bar should:

* fade into the background
* tell you what matters
* never demand attention

This implementation does exactly that.
