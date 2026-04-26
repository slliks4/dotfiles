# Dotfiles

Slliks4 Personal system configuration and dotfiles.

This repository is structured as a modular system build, starting from a
minimal Arch installation and progressing into a configurable environment.

The focus is on:
- minimalism
- portability
- explicit configuration
- reproducibility through documentation

---

## Status

Work in progress.

Some modules are incomplete or being refactored.  
Each directory is intended to contain its own `README.md`.

---

## Repository Layout

```

arch/        Base system installation
grub/        Bootloader and dual boot configuration
shared/      Cross-environment tools and system components
x11/         Xorg-based environment
wayland/     Wayland-based environment (WIP)

````

Each component is self-contained and can be installed independently.

---

## Setup Flow

This flow produces a complete **minimal working system**.

At the end of this process, the system is usable from the terminal and
ready to branch into a display environment (or remain headless).

---

### 0. Base System (Arch)

Goal: obtain a minimal, bootable system.

Includes:
- partitioning and formatting
- pacstrap installation
- fstab generation
- locale and timezone configuration
- user setup
- initial boot

See:
- `arch/README.md`

---

### 1. Bootloader (GRUB)

Goal: stable and predictable boot process.

Includes:
- UEFI GRUB installation
- os-prober configuration
- Windows detection (if present)
- firmware-specific workarounds
- optional theme setup

See:
- `grub/README.md`

---

### 2. Core CLI Environment

Goal: establish a usable terminal workflow.

```bash
sudo pacman -Syu
sudo pacman -S zsh git tmux neovim
````

See:

* `shared/dev/zsh/README.md`
* `shared/dev/git/README.md`
* `shared/dev/tmux/README.md`
* `shared/dev/nvim/README.md`

---

### 3. System Foundation

Goal: stable base system independent of display protocol.

This layer is shared across all environments (X11, Wayland, or headless).

Includes:

* GPU drivers
* fonts
* audio (PipeWire)
* core system configuration

See:

* `shared/system/README.md`
* `shared/system/gpu/README.md`
* `shared/system/fonts/README.md`
* `shared/system/audio/README.md`

---

## Next Steps

At this point, the system is complete as a minimal environment.

You may choose to stop here or continue into a display layer.

---

### X11 Path

See:

* `x11/README.md`

This path will include:

* display server setup
* window manager
* system utilities
* applications

---

### Wayland Path

See:

* `wayland/README.md`

This path will include:

* compositor setup
* modern replacements for X11 tools
* system utilities
* applications

---

## Installation Model

There is no global install script.

Each module provides its own installation entry point.

Example:

```bash
cd shared/dev/git
./install.sh
```

This approach ensures:

* full control over each component
* transparent configuration
* easier debugging and modification

---

## Design Principles

* terminal-first workflow
* minimal and explicit configuration
* modular structure
* no hidden automation
* reproducible setup
* understanding over abstraction

---

## Notes

* Some modules are incomplete or being standardized
* Wayland support is not finalized
* Structure may evolve as modules stabilize

---

## Future Work

* unify install script conventions
* dependency validation per module
* expand Wayland support
* standardize module documentation
