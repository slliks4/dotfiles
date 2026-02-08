# Zsh — Shell Environment

This module configures the **interactive shell environment** using **zsh**.

It is:

* system-level
* window-manager agnostic
* loaded for every interactive shell
* safe to re-run
* independent of development tooling

---

## What This Module Does

* Installs and enables **zsh**
* Sets **zsh as the default shell**
* Installs **Oh My Zsh**
* Enables a **minimal plugin set**
* Links a managed `.zshrc` as the single source of truth

The result is a shell that is:

* fast
* predictable
* reproducible
* suitable for terminal- and Vim-centric workflows

---

## How It Works

The module provides a curated `.zshrc` and an installer script.

The installer:

* installs required system packages (if missing)
* installs Oh My Zsh
* installs required plugins
* backs up any existing `.zshrc`
* symlinks the managed configuration into `$HOME`

No runtime hacks or shell magic are used.

---

## Usage

Run the installer once:

```sh
cd system/zsh
./install.sh
```

After installation, log out and back in (or reboot) to start using `zsh`.

---

## Philosophy

Shell configuration should be:

* minimal
* explicit
* global
