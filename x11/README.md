# X11 Base Setup (with dwm)

This document covers the **minimum X11 bring-up** required to reach a usable
graphical session using **dwm**.

**Scope:**

* Xorg installation
* dwm fork base build
* terminal access
* `.xinitrc`
* first successful `startx`

Advanced dwm customization (patches, bars, visuals, workflows) is documented in the dwm fork repository:
👉 [https://github.com/slliks4/dwm](https://github.com/slliks4/dwm)

---

## 📚 Sources

* Arch Wiki — Xorg
  [https://wiki.archlinux.org/title/Xorg](https://wiki.archlinux.org/title/Xorg)
* Arch Wiki — Xinit
  [https://wiki.archlinux.org/title/Xinit](https://wiki.archlinux.org/title/Xinit)
* Arch Wiki — dwm
  [https://wiki.archlinux.org/title/Dwm](https://wiki.archlinux.org/title/Dwm)

---

## 1️⃣ Install the Minimum X11 Stack

```bash
sudo pacman -S xorg-server xorg-xinit
```

This provides:

* Xorg server
* `Xorg` binary
* `startx`
* base X session support

✅ This is the **minimum required** to run X11.

---

## 2️⃣ Install dwm Build Dependencies

```bash
sudo pacman -S base-devel libx11 libxinerama libxft
```

Why these are required:

* `base-devel` → `make`, `gcc`
* `libx11` → core X11 library
* `libxinerama` → multi-monitor support
* `libxft` → font rendering (mandatory)

---

## 3️⃣ Install a Terminal (Required)

A terminal is required to interact with dwm.

For now, install **alacritty**:

```bash
sudo pacman -S alacritty
```

Other tools (file managers, previews, etc.) are intentionally deferred.

---

## 4️⃣ Install an AUR Helper (paru)

```bash
mkdir -p ~/aur
cd ~/aur
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

---

## 5️⃣ Fonts (Minimal / Retro)

Install base fonts:

```bash
sudo pacman -S ttf-dejavu terminus-font
```

Optional retro-style fonts from AUR:

```bash
paru -S spleen-font tamsyn-font
```

Fonts are required for readable dwm text rendering.

---

## 6️⃣ dwm (install from your fork)

> Keep dwm source **outside** dotfiles.
> Dotfiles/X11 docs describe *how to install*, while the dwm fork repo contains *the configuration*.

**Paths used:**

* Source code: `/usr/local/src/dwm`
* Config + docs: dwm fork repository

```bash
# Prepare source dir (once)
sudo mkdir -p /usr/local/src
sudo chown -R "$USER:$USER" /usr/local/src

# Clone your fork (not upstream)
cd /usr/local/src
git clone https://github.com/slliks4/dwm.git
cd dwm

# Build + install
sudo make clean install
```

Fork repo:
👉 [https://github.com/slliks4/dwm](https://github.com/slliks4/dwm)

---

## 7️⃣ dwm Configuration Location

dwm is configured by editing and rebuilding:

* `/usr/local/src/dwm/config.h`

Apply changes with:

```bash
cd /usr/local/src/dwm
sudo make clean install
```

---

## 8️⃣ Create `.xinitrc`

```bash
nvim ~/.xinitrc
```

Minimal content:

```sh
#!/bin/sh
exec dwm
```

(Optional safer version)

```sh
#!/bin/sh
exec dbus-run-session dwm
```

Make it executable:

```bash
chmod +x ~/.xinitrc
```

---

## 9️⃣ Start X11 (First Real Test)

From a **TTY** (not SSH):

```bash
startx
```

---

## ✅ Success Criteria

X11 is considered **successfully set up** when:

* `startx` launches dwm
* a status bar appears
* `Mod + Enter` opens a terminal
* windows tile and close correctly
* X exits cleanly

If this works, X11 bring-up is complete.

---

## 🚫 Out of Scope (Handled Later)

Intentionally not configured yet:

* dwm patches and cosmetics
* compositor
* audio (PipeWire)
* brightness and power management
* screen sharing
* clipboard tools
* NVIDIA tuning

These are layered **after X11 stability** is confirmed.

---

## 🔜 Next Step

Proceed to:
👉 `https://github.com/slliks4/dwm/README.md` — patches, cosmetics, workflow
