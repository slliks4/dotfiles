# X11 — Shared Modules

This directory contains **X11-specific modules** that are shared across window managers.

These modules:

- depend on X11
- are independent of any specific window manager
- extend the session via `conf.d`

---

## Scope

Examples include:

- display configuration
- input setup
- compositor
- notifications
- screenshot and recording tools

---

## Usage

Each module provides its own `install.sh`.

Modules typically:

- install required packages
- place scripts into:

```bash
~/.config/x11/conf.d/
````

These scripts are loaded at session start by the window manager.

---

## Notes

* modules are optional and independent
* safe to install or remove individually
* do not modify `.xinitrc`
