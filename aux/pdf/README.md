# Zathura — PDF Viewer

This directory sets up **Zathura**, a minimal keyboard-driven PDF viewer.

Zathura is used as the default PDF viewer for this system due to its:

- speed and low resource usage
- Vim-style navigation
- simple text configuration
- zero background services

---

## 📦 Installation

From the dotfiles root:

```sh
cd aux/zathura
./install.sh
````

This will:

* install `zathura` and `zathura-pdf-mupdf`
* symlink `zathurarc` to `~/.config/zathura/`
* optionally add a `pdf` alias to `.zshrc`

---

## ⌨️ Keybindings

Navigation follows Vim conventions:

| Key      | Action              |
| -------- | ------------------- |
| `j / k`  | scroll down / up    |
| `h / l`  | scroll left / right |
| `gg / G` | top / bottom        |
| `/ / ?`  | search              |
| `+ / -`  | zoom                |

---

## 📁 Configuration

Config file location:

```text
~/.config/zathura/zathurarc
```

The file is symlinked from:

```text
~/.dotfiles/aux/zathura/zathurarc
```

---

## 🧠 Notes

* Clipboard integration uses the system clipboard
* No GUI menus or mouse interaction required
* Works well with tiling window managers
