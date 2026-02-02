# dwm Keybindings

This document explains the **intent and structure** of the current dwm keymap.

The goal of this keymap is:
- clarity over cleverness
- explicit actions instead of hidden state
- bindings that match muscle memory
- a small, learnable surface area

Most bindings are documented **inline** in `config.h`.
This file exists to explain *why certain defaults were removed* and *where to look*.

---

## Where Keybindings Live

All keybindings are defined in:

```

dwm/config.h

````

Specifically in:

```c
static const Key keys[] = { ... };
````

Each binding includes an inline comment describing its purpose.
This README does not duplicate those comments.

---

## Design Principles

### Explicit Over Implicit

Several default dwm bindings were intentionally removed or commented out, including:

* layout cycling
* tag toggling
* multiple master windows

These features introduce hidden state and slow down learning.
Layouts and actions are selected **explicitly** via dedicated keys.

---

### One Action Per Key

Each binding performs **one clear action**:

* launch menu
* launch terminal
* close window
* change layout
* move focus
* switch tags or monitors

There are no overloaded or context-sensitive bindings.

---

### Safer Defaults

Destructive actions are intentionally harder to trigger:

* Close window:
  `Mod + Backspace`

* Quit dwm:
  `Mod + Shift + q`

This reduces accidental disruption during daily use.

---

## High-Level Keymap Overview

This is a **conceptual summary**, not an exhaustive list.

### Application Launching

* `Mod + Space` → application menu (`dmenu`)
* `Mod + Enter` → terminal

### Window Navigation

* `Mod + j / k` → move focus through stack
* `Mod + m` → promote focused window to master

### Layout Selection

* `Mod + d` → tiled layout
* `Mod + f` → monocle layout

Layout cycling is intentionally disabled.

---

### Tag Navigation

* `Mod + 0–9` → view tag
* `Mod + Shift + 0–9` → move window to tag
* `Mod + Tab` → toggle between current and previous tag

Advanced tag toggling (`toggleview`, `toggletag`) is not used for now.

---

### Multi-Monitor

* `Mod + , / .` → focus previous / next monitor
* `Mod + Shift + , / .` → move window to previous / next monitor

---

## Why Some dwm Defaults Are Missing

The following features are intentionally postponed:

* `incnmaster`
* layout cycling
* tag toggling

They are powerful but add cognitive overhead early on.
Nothing is permanently removed — only deferred until needed.

---

## Documentation Philosophy

* `config.h` is the authoritative source
* comments live next to the code they explain
* this file provides context, not repetition

Missing features are expected to surface naturally through use.
