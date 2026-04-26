# Tmux

Installs and configures tmux.

This module provides a terminal multiplexer setup used as part of the
development workflow.

Tmux is treated as a core tool:
- usable in TTY, SSH, and graphical environments
- independent of display protocol
- resilient to disconnects

---

## Installation

```bash
./deploy.sh
````

---

## Includes

* tmux
* fzf
* tmux plugin manager (TPM)
* core plugins:

  * tmux-resurrect
  * tmux-continuum
* `ts` session helper script

---

## Configuration

* `.tmux.conf` is managed by this module
* configuration is symlinked to `$HOME/.tmux.conf`
* a base config is created if none exists

Plugins are installed automatically, but may require initialization.

---

## Post-Install

Start tmux and run:

```text
prefix + Shift + I
```

to finalize plugin installation.

---

## Notes

* configuration is idempotent and safe to re-run
* module is independent of window manager or display server
* behavior is documented inside `.tmux.conf`

---

## Documentation

Usage, workflows, and keybindings:

* `docs/`

## Reference

* TPM: [https://github.com/tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
