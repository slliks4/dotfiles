# System Utilities

This document covers **base system utilities** layered on top of X11 + dwm.
These utilities improve **daily usability** but are intentionally kept
minimal and optional.

---

## 📌 Scope

This section includes system-level tools that are:

- window-manager agnostic
- layered *after* X11 is working
- independent of dwm patches or cosmetics

Things Contained in this README:
- brightness control
- audio
- gpu setup 
- Keyboard setup
- display (monitor and wallpaper) setup
- clipboard
- notifications
- power utilities

Each subsection can be set up independently.

---

## 💡 Brightness Control (Laptop)

Screen brightness is required for basic laptop usability.

### Install `light`

```bash
paru -S light
````

---

### Set Backlight Permissions

Allow non-root access to backlight controls:

```bash
sudo tee /etc/udev/rules.d/90-backlight.rules > /dev/null <<EOF
ACTION=="add", SUBSYSTEM=="backlight", \
RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
EOF
```

Add the user to the `video` group:

```bash
sudo usermod -aG video $USER
```

⚠️ Reboot required for permissions to take effect.

---

### Usage

```bash
light        # show brightness (0–100%)
light -A 10  # increase brightness by 10%
light -U 10  # decrease brightness by 10%
```

These commands can later be bound to dwm keys.

---

## 🎧 Audio (PipeWire)

Audio is configured after X11 is confirmed stable.

### Install Volume Control

```bash
sudo pacman -S pavucontrol
```

This provides a simple GUI mixer.

---

### CLI Audio Tools (Optional)

Terminal-based alternatives:

* `wpctl`
* `pamixer`
* `pactl`

Example:

```bash
wpctl get-volume @DEFAULT_AUDIO_SINK@
```

---

## 💡 GPU Setup (Intel / AMD / NVIDIA)

This system is designed to run **Intel graphics as the primary and recommended configuration**.

- **Intel GPU** → default and preferred (open, in-kernel, stable)
- **AMD GPU** → supported as a future option (open drivers, mature stack)
- **NVIDIA GPU** → **not recommended** unless CUDA is a hard requirement

The GPU strategy prioritizes:
- kernel stability
- minimal early-boot risk
- clean X11 / Wayland integration
- low maintenance overhead

📄 Full rationale and vendor-specific notes:
- [gpu/README.md](gpu/README.md)

---

## ⌨️ Keyboard (X11)

**Purpose:**  
Define global keyboard behavior before the window manager starts.

This module handles:
- Caps Lock remapping
- future layout or modifier adjustments

Applied via `setxkbmap` and sourced from `.xinitrc` before display and WM startup.

📄 Detailed setup:
- [keyboard/README.md](keyboard/README.md)

---

## 💡 Display (X11)

**Purpose:**  
Deterministic multi-monitor layout, refresh rates, rotation, and wallpaper setup.

Handled via:
- `xrandr` for geometry and refresh control
- `feh` for root window wallpaper

Key characteristics:
- explicit `--pos` coordinates (no relative placement)
- safe fallbacks when monitors are disconnected
- WM-agnostic (runs before `dwm` starts)
- portable across home / school / laptop-only setups

📄 Detailed setup:
- [display/README.md](display/README.md)

---

## 🧭 Application Menu

**Purpose:**  
Keyboard-driven application launching and script execution.

This module provides a minimal, WM-agnostic menu for:
- launching applications
- running user scripts
- quick command access

The initial implementation uses `dmenu`,
with the option to replace it later if needed.

📄 Detailed setup:
- [menu/README.md](menu/README.md)

---

## 📊 Status Bar (dwm)

Provides a **lightweight system status bar** using `xsetroot`.

Displays:

* network state (ETH / WIFI / OFF)
* CPU usage
* memory usage
* battery status (if present)
* date and time

Key properties:

* runs independently of `dwm` (no patches)
* low refresh rate (no flicker)
* useful outside of tmux (reading, meetings, browsing)
* easy to extend later

Handled via a background script launched from `.xinitrc`.

📄 Detailed setup:

* [status/README.md](status/README.md)

---

## 🔔 Notifications (dunst)

Lightweight desktop notifications for X11.

This setup uses **`dunst`**, a minimal notification daemon that works well with `dwm` and avoids Wayland-specific tools.

**Purpose:**

* screenshot feedback
* system alerts
* application notifications

**Why dunst:**

* fast and lightweight
* no compositor required
* WM-agnostic
* minimal configuration

Notifications are started once per X session via `.xinitrc`.

📄 Detailed setup:

* [notifications/README.md](notifications/README.md)

---

## 📸 Screenshot (X11)

Lightweight screenshot utility for X11 sessions.

Provides:

* area selection screenshots
* clipboard-first workflow
* optional file saving
* optional local HTTP sharing (single file, no history)
* notifications via `notify-send`

Designed to be:

* window-manager agnostic
* compositor-free
* secure by default (no exposure of old screenshots)

📄 Detailed setup and usage:

* [screenshot/README.md](screenshot/README.md)

---

# 🧠 Notes

* Each utility here is optional
* Nothing in this file is required for X11 or dwm to function
* Tools are added incrementally as needed
* Configuration remains minimal by design

---

# 🔜 Planned Additions

The following may be added later as needed:

* clipboard utilities
* power management helpers

These will be documented here when introduced.
