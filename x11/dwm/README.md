# dwm — Dynamic Window Manager (X11)

This module installs and configures **dwm** as an X11 window manager.

The setup follows the system design:

- shared X11 configuration via `conf.d`
- `.xinitrc` defines the active window manager
- no runtime switching logic or state tracking

---

## What This Module Does

- installs required X11 and build dependencies
- clones dwm from your fork:

```text
/usr/local/src/dwm
````

* builds and installs dwm via `make install`
* rewrites `~/.xinitrc` to launch dwm
* preserves shared system setup via:

```text
~/.config/x11/conf.d/
```

---

## Installation

From the dotfiles root:

```sh
cd x11/dwm
./install.sh
```

Then start X:

```sh
startx
```

---

## Startup Model

The system uses a shared startup layer:

```sh
~/.xinitrc
```

Example:

```sh
CONF_DIR="$HOME/.config/x11/conf.d"

for file in "$CONF_DIR/"*.sh; do
  [ -x "$file" ] && "$file"
done

exec dwm
```

---

## Shared Configuration

All environment setup is handled through:

```text
~/.config/x11/conf.d/
```

Examples:

* display configuration
* keyboard layout
* compositor (picom)
* notifications

These are reused across all window managers.

---

## Window Manager Selection

Only one window manager runs per session.

Installing this module sets:

```sh
exec dwm
```

To switch to another window manager (e.g. i3):

```sh
cd x11/i3
./install.sh
```

---

## Notes

* dwm is built from source and installed system-wide
* configuration is handled in the dwm source (`config.h`)
* rebuilding requires running:

```sh
cd /usr/local/src/dwm
sudo make clean install
```

---

## Philosophy

This setup prioritizes:

* explicit configuration
* minimal abstraction
* shared system components
* predictable startup behavior

The window manager is treated as a replaceable component,
while the rest of the system remains consistent.
