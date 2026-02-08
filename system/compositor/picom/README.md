# Picom (X11 Compositor)

This module configures **picom** as the X11 compositor.

It is used only to provide:
- window transparency
- basic compositing support

No visual effects, animations, or desktop-level behavior are enabled.

---

## What This Module Does

- Enables transparency for selected applications
- Allows terminal opacity (e.g. Alacritty)
- Keeps the compositor lightweight and unobtrusive

This setup intentionally avoids:
- blur
- shadows
- animations
- rounded corners

---

## Why Picom Is Needed

On X11, applications like terminal emulators can **request opacity**,  
but a compositor is required to actually render transparency.

Without picom:
- `window.opacity` settings are ignored
- terminals remain fully opaque

Picom fills this gap with minimal overhead.

---

## Installation

Install picom using your system package manager:

```sh
sudo pacman -S picom
````

---

## Configuration

A minimal configuration is used, for example:

```conf
backend = "xrender";
vsync = false;

opacity-rule = [
  "85:class_g = 'Alacritty'"
];
```

This applies opacity only to Alacritty windows.

---

## Startup

Picom should be started once per X session.

Recommended place: `.xinitrc`

```sh
picom &
```

This ensures the compositor is running before the window manager starts.

---

## Philosophy

The compositor should be:

* invisible
* predictable
* policy-driven

Picom exists here only to support transparency where explicitly requested,
and otherwise stays out of the way.
