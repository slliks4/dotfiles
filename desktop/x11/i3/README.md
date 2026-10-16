# i3 — Window Manager

This module installs and configures the **i3 tiling window manager**.

It defines the X11 session by creating `.xinitrc` and launching `i3`.

---

## Scope

- installs `i3-wm`
- links i3 configuration
- creates `.xinitrc`
- loads X11 session modules from `conf.d`

This module does **not**:

- install X11 (handled by `x11/base`)
- install terminal or launcher
- configure system modules (display, input, etc.)

---

## Installation

```bash
./install.sh
````

---

## Session Behavior

`.xinitrc` is recreated by this module and will:

* load all executable scripts from:

```bash
~/.config/x11/conf.d/
```

* start the i3 session:

```bash
exec i3
```

---

## Dependencies

Ensure X11 base is installed first:

```bash
x11/base/install.sh
```

---

## Required Modules

i3 expects a terminal and launcher to be available.

Install separately:

* terminal → `shared/dev/alacritty` (or similar)
* launcher → `x11/shared/dmenu`

---

## Configuration

The i3 config is managed from this module and symlinked to:

```bash
~/.config/i3/config
```

---

## Usage

Start the session:

```bash
startx
```

---

## Notes

* `.xinitrc` is owned by this module and may be overwritten on reinstall
* session extensions should be added via `conf.d`, not by modifying `.xinitrc`
* safe to re-run

---

## Next Step

Add X11 modules:

* display setup
* input configuration
* compositor
* notifications
