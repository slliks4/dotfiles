# System

Core system components shared across all environments.

This layer provides system-level functionality required before any
display environment is configured.

It is independent of:
- X11
- Wayland
- window managers

---

## Usage

Each module is self-contained.

Navigate to a module and run its install script.

Example:

```bash
cd gpu
./nvidia/install.sh
````

---

## Scope

This layer includes:

* hardware support (GPU drivers)
* fonts
* audio (PipeWire)
* base system configuration

---

## Notes

* modules are independent and optional
* install only what is required for your system
* configuration here applies to all environments

---

## Documentation

Each module contains its own `README.md`.
