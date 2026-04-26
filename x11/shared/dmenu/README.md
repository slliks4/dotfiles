# dmenu — Application Launcher

This module installs **dmenu**, a minimal application launcher for X11.

---

## Scope

- installs `dmenu`

This module does **not**:

- configure keybindings
- manage window manager integration

---

## Installation

```bash
./install.sh
````

---

## Usage

dmenu is typically launched from a window manager keybinding.

Example (i3):

```bash
bindsym $mod+d exec dmenu_run
```

---

## Notes

* requires X11
* not compatible with Wayland
* safe to re-run
