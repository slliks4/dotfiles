# Screenshot Utility (X11)

This module provides a **simple, secure screenshot workflow** for X11 systems.

It is designed to be:

* clipboard-first minimal and predictable
* window-manager agnostic
* safe for local network sharing
* free of background services

The script intentionally avoids compositors and Wayland-specific tools.

---

## Features

* area selection screenshots
* clipboard copy (default behavior)
* optional file saving
* optional HTTP sharing for tablet / second device access
* notifications via `notify-send`
* no screenshot history exposure over HTTP

---

## Usage

The script is installed to:

```text
~/.config/system/screenshot/screenshot.sh
```

### Default (select → copy)

```bash
screenshot
```

Select an area and copy the image to the clipboard.

---

### Save screenshot (select → save + copy)

```bash
screenshot save
```

Saved to:

```text
~/Pictures/Screenshots/
```

---

### Full screen (save only)

```bash
screenshot full
```

---

### Share over HTTP (select → copy + serve)

```bash
screenshot http
```

* Serves a **single fixed image** at:

  ```text
  http://<local-ip>:8000/http.png
  ```
* Old screenshots are not accessible
* Previous HTTP servers are stopped before starting a new one

---

### Share + save

```bash
screenshot http-save
```

---

## Security Notes

* Only **one file** is exposed over HTTP (`http.png`)
* The file is overwritten on every capture
* The HTTP server is restarted per screenshot
* No directory browsing of historical screenshots is possible

This design intentionally avoids:

* random filenames
* temp directories
* persistent background services

---

## Dependencies

Required tools:

* `maim` – screenshot capture
* `slop` – interactive selection
* `xclip` – clipboard access
* `libnotify` – notifications
* `python` – local HTTP server (for HTTP mode)

Dependencies are handled automatically by `install.sh`.

---

## Installation

From the dotfiles repository:

```bash
cd ~/.dotfiles/system/screenshot
./install.sh
```

This will:

* install missing dependencies
* symlink the script to the XDG bin path
* make it executable

---

## Philosophy

Screenshots should be:

* fast
* boring
* reliable
* disposable

This module exists so screenshots never need revisiting or rethinking.

