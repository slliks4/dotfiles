# X11 Base Setup (with dwm)

This document covers the **minimum X11 bring-up** required to reach a usable
graphical session using **dwm**.
Scope:
- Xorg installation
- dwm base build (no patches)
- terminal access
- `.xinitrc`
- first successful `startx`

Cosmetics, patches, bars, and advanced dwm customization are documented
separately in `dwm/README.md`.

---

## 📚 Sources

- Arch Wiki — Xorg  
  https://wiki.archlinux.org/title/Xorg
- Arch Wiki — Xinit  
  https://wiki.archlinux.org/title/Xinit
- Arch Wiki — dwm  
  https://wiki.archlinux.org/title/Dwm

---

## 1️⃣ Install the Minimum X11 Stack

From the Arch Wiki (Xorg → Installation):

```bash
sudo pacman -S xorg-server xorg-xinit
````

This provides:

* Xorg server
* `Xorg` binary
* `startx`
* base X session support

✅ This is the **minimum required** to run X11.

---

## 2️⃣ Install dwm Build Dependencies

From the dwm documentation:

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

Other tools (file managers, previews) are intentionally deferred.

---

## 4️⃣ Install an AUR Helper (paru)

Some fonts and later tools are sourced from the AUR.

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

## 6️⃣ Build and Install dwm (Base)

Clone dwm into a system source directory:

```bash
sudo mkdir -p /usr/local/src
sudo git clone https://git.suckless.org/dwm /usr/local/src/dwm
sudo chown -R $USER:$USER /usr/local/src/dwm
```

Build and install:

```bash
cd /usr/local/src/dwm
sudo make clean install
```

⚠️ No patches are applied at this stage.

(Optional: prepare for patch tracking later)

```bash
git init
git remote add origin https://git.suckless.org/dwm
```

---

## 7️⃣ Create `.xinitrc`

From Arch Wiki → Xinit.

Create the file:

```bash
nvim ~/.xinitrc
```

Minimal content:

```sh
#!/bin/sh
exec dwm
```

Make it executable:

```bash
chmod +x ~/.xinitrc
```

---

## 8️⃣ Basic dwm Key Configuration (Optional but Practical)

dwm is configured by editing `config.h` and recompiling.

Open the config file:

```bash
cd /usr/local/src/dwm
sudo nvim config.h
```

---

### 🔑 Set the Modifier Key (Super / Windows Key)

Find the line defining `MODKEY`:

```c
#define MODKEY Mod1Mask
```

Change it to use the **Super (Windows) key**:

```c
#define MODKEY Mod4Mask
```

---

### 🖥 Set the Default Terminal (Alacritty)

Search for the terminal definition:

```c
static const char *termcmd[] = { "st", NULL };
```

Update it to use **alacritty**:

```c
static const char *termcmd[] = { "alacritty", NULL };
```

---

### ⌨️ Set Terminal Keybinding (Mod + Enter)

Locate the keybindings section:

```c
static const Key keys[] = {
```

Find the terminal binding (default example):

```c
{ MODKEY|ShiftMask, XK_Return, spawn, {.v = termcmd } },
```

Change it to **Mod + Enter**:

```c
{ MODKEY, XK_Return, spawn, {.v = termcmd } },
```

---

### Set Focus Keybinding (Mod + Shift + Enter)

Locate the keybindings section:

```c
static const Key keys[] = {
```

Find the zoom binding (default example):

```c
{ MODKEY,       XK_Return, zoom,           {0} }
```

Change it to **Mod + Shift + Enter**:

```c
{ MODKEY|ShiftMask,             XK_Return, zoom,           {0}
```

---

### 🔄 Rebuild dwm

After making changes, recompile and install:

```bash
sudo make clean install
```

Restart X (or log out and run `startx` again) to apply changes.

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
* windows can be tiled and closed
* X exits cleanly

If this works, X11 bring-up is complete.

---

## 🚫 Out of Scope (Handled Later)

The following are intentionally **not configured yet**:

* dwm patches and cosmetics
* compositor
* audio (PipeWire)
* brightness and power management
* screen sharing
* clipboard tools
* NVIDIA tuning

These are layered on **after X11 stability** is confirmed.

---

## 🔜 Next Step

Proceed to:

* `dwm/README.md` → patches, cosmetics, workflow
