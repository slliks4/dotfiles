# Dotfiles

My personal dotfiles and app configurations. These are focused on portability and
minimalism for terminal-based development.

This repository also serves as a **step-by-step system build flow** — from a
fresh Arch ISO to a complete workstation (X11 + dwm + development tooling).

> The top-level README stays lightweight and chronological.  
> Each major component has its own dedicated README for details.

---

## 📌 Setup Flow

### ✅ Step 0 — Install Arch (Base System)
**Goal:** a working, bootable system with networking and a clean base install.

Includes (high-level):
- disk partitioning + formatting
- mounting + pacstrap
- fstab
- chroot + base configuration (locale, timezone, users)
- first successful boot

📄 Detailed guide:  
- [arch/arch/README.md)

---

### ✅ Step 1 — Base Tools (CLI Workflow)
**Goal:** install the minimum tools needed to work comfortably and document changes.

```bash
sudo pacman -Syu
sudo pacman -S git tmux neovim
````

Notes:

* `tmux` is used for a multi-pane workflow during setup
* `git` is used to pull dotfiles and track changes
* `neovim` is used for editing configs and documentation

📄 Related:

* [dev/tmux/README.md](dev/tmux/README.md)
* [dev/nvim/README.md](dev/nvim/README.md)
* [dev/git/README.md](dev/git/README.md)

---

### ✅ Step 2 — Bootloader + Dual Boot (GRUB)

**Goal:** a stable GRUB setup with Windows dual boot and sane defaults.

Includes:

* clean GRUB reinstall (UEFI)
* enabling `os-prober`
* mounting a separate Windows EFI partition (if applicable)
* optional HP firmware override workaround
* GRUB theme installation via `.dotfiles/grub/install.sh`
* fixing default kernel selection

📄 Detailed guide:

* [grub/README.md](grub/README.md)

---

### ✅ Step 3 — X11 Base Setup (with dwm)

**Goal:** reach a usable graphical session with a minimal window manager.

Includes:

* installing the minimal Xorg stack
* building and installing base dwm (no patches)
* configuring `.xinitrc`
* terminal access and fonts
* first successful `startx`

📄 Detailed guide:

* [x11/README.md](x11/README.md)

---

### 🚧 Step 4 — System Utilities

**Goal:** improve daily laptop usability while keeping the system minimal and stable.

Examples:

* screen brightness
* audio (PipeWire)
* GPU strategy (Intel-first, AMD optional, NVIDIA discouraged)
* Monitor and wallpaper settings
* other desktop-adjacent tools

This step is intentionally modular — nothing here is required for X11 or dwm to function.
Each utility can be adopted independently.

📄 Detailed guide:

* [system/README.md](system/README.md)

---

### 🚧 Step 5 — dwm Customization

**Goal:** evolve dwm beyond the base setup.

Planned:

* patch management strategy
* keybindings, layouts, rules
* visuals
* autostart workflow

* [https://github.com/slliks4/dwm](https://github.com/slliks4/dwm)

---

### ⏭ Step 6 — Applications & Tooling

This stage covers **user-facing applications** and **development tooling**.
Both are layered *after* the base system and window manager are stable.

---

### 🧰 Auxiliary Applications

**Goal:** everyday usability and communication.

Includes:
- chat and communication apps (e.g. Discord)
- proprietary or self-updating binaries
- general-purpose user applications

These tools are kept separate from system configuration
and may be installed outside the system package manager when appropriate.

📄 Details:
- [aux/README.md](aux/README.md)

---

### 💻 Development Environment

**Goal:** programming-ready workstation.

Includes:
- compilers and build tools
- language toolchains (Node, Python, Go, etc.)
- editor and terminal tooling
- container workflows (Docker, etc.)
- SSH keys, GPG, and secrets management

Development tooling is isolated so it can evolve
without impacting system stability or daily applications.

📄 Details:
- [dev/README.md](dev/README.md)

---

### Browser Scrolling Note

Smooth scrolling can cause text "wobble" or bouncing on X11,
especially in tiling window managers.

Recommended:
- Disable smooth scrolling in the browser for crisp text rendering.

---

## ✅ Philosophy

* terminal-first
* minimal but practical
* reproducible steps (documentation > magic)
* each module is installable independently
* keep “how it works” and “why it works” close to the relevant configuration
