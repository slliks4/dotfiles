# Dictionary helper (dict)

This module provides a small clipboard-aware dictionary utility for
**Arch Linux (X11)**.

It is a developer convenience tool and lives under `dev/`, not the system layer.

---

## What This Tool Does

- Looks up English word definitions
- Reads input from:
  - command argument
  - X11 primary selection
- Displays results using desktop notifications
- Avoids opening browsers or terminals

---

## Requirements

- Arch Linux
- X11
- `curl`
- `jq`
- `xclip`
- `libnotify`

---

## Installation

From the dotfiles root:

```sh
cd dev/dict
chmod +x dict
ln -s "$PWD/dict" ~/.local/bin/dict
````

Ensure `~/.local/bin` is in your `$PATH`.

---

## Usage

### Lookup a word explicitly

```sh
dict kernel
```

### Lookup selected text

Select a word with the mouse, then run:

```sh
dict
```

---

## Output

* First definition per part of speech
* Displayed via `notify-send`
* Automatically dismisses after a short delay

---

## Philosophy

This tool exists to:

* reduce context switching
* stay keyboard-driven
* keep tooling minimal
* integrate naturally into X11 workflows

It does not manage:

* offline dictionaries
* history or caching
* pronunciation audio

Those concerns belong elsewhere.
