# Git

Installs and configures Git.

This module:
- installs required packages
- sets a minimal global configuration
- links `.gitconfig` to `$HOME`

---

## Installation

```bash
./install.sh
````

---

## Includes

* git
* less (pager)
* man-db
* man-pages

---

## Configuration

A minimal `.gitconfig` is created if none exists.

Current defaults:

* default branch set to `main`
* GitHub credential helper via `gh` (if available)

---

## Notes

* `.gitconfig` is managed by this module
* existing configuration will be replaced by a symlink
* extend configuration manually if needed

---

## Documentation

Usage, workflows, and additional tools are documented separately:

* `docs/`
