# Tmux

This module provides a **terminal multiplexer setup** used as part of the
development workflow.

Tmux is treated as a **core development primitive**:
- usable inside or outside X
- independent of the window manager
- suitable for SSH, TTY, and graphical sessions
- resilient to disconnects and reboots

---

## 📦 Installation

```bash
sudo pacman -S tmux
````

---

## ⚙️ Setup

### Recommended: Deploy script

```bash
cd ~/.dotfiles/dev/tmux
./deploy.sh
```

This script:

* symlinks `.tmux.conf`
* installs TPM (tmux plugin manager)
* installs core plugins
* installs `fzf` if missing
* symlinks the `ts` helper script into `~/.local/bin`

The script is **idempotent** and safe to re-run.

---

### Manual setup (optional)

Only required if you do not want to use `deploy.sh`.

```bash
ln -sf ~/.dotfiles/dev/tmux/.tmux.conf ~/.tmux.conf
```

Install TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Install plugins:

```bash
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.config/tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum ~/.config/tmux/plugins/tmux-continuum
```

Link the helper script:

```bash
mkdir -p ~/.local/bin
ln -sf ~/.dotfiles/dev/tmux/ts ~/.local/bin/ts
chmod +x ~/.local/bin/ts
```

Install dependency:

```bash
sudo pacman -S fzf
```

---

## 🔌 Plugins

Plugin configuration is handled via TPM.

After starting tmux:

```text
prefix + Shift + I
```

to install plugins, or:

```bash
tmux source-file ~/.tmux.conf
```

to reload the configuration.

---

## 🔍 Helper Script

### `ts`

A small helper for fuzzy tmux session management.

* Source: `~/.dotfiles/dev/tmux/ts`
* Installed to: `~/.local/bin/ts`
* Requires: `fzf`

---

## 🧠 Notes

* tmux configuration is fully independent of dwm or X11
* the module can be installed or removed without affecting the system
* all behavior is documented inline in `.tmux.conf`

---

## 🔗 Reference

* TPM: [https://github.com/tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
