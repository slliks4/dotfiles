# MPV

Installs and configures MPV.

This module:

* installs required packages
* provides a minimal configuration
* links `mpv.conf` to `$HOME/.config/mpv`

---

## Installation

```bash
./install.sh
```

---

## Includes

* mpv
* yt-dlp (for online playback)
* ffmpeg

---

## Configuration

A minimal `mpv.conf` is provided if none exists.

Current defaults:

* hardware acceleration enabled
* sane cache and performance settings
* clean, minimal UI (no clutter)

---

## Notes

* `mpv.conf` is managed by this module
* existing configuration will be replaced by a symlink
* additional configs (input.conf, scripts) can be added manually

---

## Documentation

Usage, keybindings, and advanced configuration:

* `docs/`
