# Tmux Basics

This document describes usage and behavior based on the current configuration.

Prefix key:
```

Ctrl + Space

```

Alternate prefix:
```

Ctrl + A

````

---

## Sessions

Start tmux:

```bash
tmux
````

List sessions:

```bash
tmux ls
```

Attach:

```bash
tmux attach
```

Detach:

```
prefix + q
```

Sessions are automatically restored using:

* tmux-resurrect
* tmux-continuum

---

## Windows

Create window:

```
prefix + c
```

Next / previous:

```
prefix + n
prefix + p
```

Custom:

```
prefix + b   → previous window
```

Windows auto-rename based on active process.

---

## Panes

### Splitting

Vertical split:

```
prefix + V
```

Horizontal split:

```
prefix + H
```

---

### Navigation (Vim-style)

```
prefix + h   → left
prefix + j   → down
prefix + k   → up
prefix + l   → right
```

---

### Sync panes

Run same command in all panes:

```
prefix + y
```

---

### Zoom / Focus

Toggle zoom behavior:

```
Ctrl + \
```

Behavior:

* zooms into active pane
* toggles between panes when already zoomed

---

## Copy Mode (Vim-style)

Enter copy mode:

```
prefix + [
```

Inside copy mode:

```
v   → start selection
y   → copy and exit
```

Paste:

```
prefix + p
```

---

## Configuration

Reload config:

```
prefix + r
```

Clear scrollback:

```
prefix + L
```

---

## Popups / Tools

### Session switcher (`ts`)

```
prefix + f
```

Opens popup with fuzzy session selector.

Requires:

* `ts` script
* `fzf`

---

## Plugins

Managed via TPM.

Install plugins:

```
prefix + Shift + I
```

Plugins in use:

* tmux-resurrect
* tmux-continuum

Features:

* automatic session restore
* periodic session saving (15s)
* pane content persistence

---

## Status Bar

Position:

* top

Displays:

* session name
* CPU usage
* RAM usage
* time

Visual behavior:

* amber color scheme
* active window highlighted
* zoom indicator shown on left

---

## Pane Borders

* inactive: dim
* active: green highlight

---

## Behavior

* fast escape time (no delay)
* activity monitoring enabled
* bell disabled
* automatic window renaming
* terminal set to `tmux-256color`

---

## Notes

* configuration is optimized for keyboard workflow
* designed for use inside terminal-first environments
* works across SSH, TTY, and graphical sessions
