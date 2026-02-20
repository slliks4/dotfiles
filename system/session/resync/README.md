# Session Resync

This module provides a manual **session re-synchronization script**.

It exists to recover cleanly from:

* monitor unplug / replug
* sleep / wake
* docking changes
* input state inconsistencies

No patches.
No hotplug daemons.
No automatic monitor managers.

Just a manual reset entrypoint.

---

## What It Does

The `resync-session` script re-runs installed system modules, such as:

* keyboard configuration
* trackpad configuration
* display layout

Each module injects itself into the script during installation.

The script simply executes them in order.

---

## Usage

Bind it in your window manager:

```c
{ MODKEY|ShiftMask, XK_r, spawn, {.v = resynccmd } },
```

Then press:

```
Mod + Shift + R
```

When something feels slightly off, run resync and the session realigns.

---

## Philosophy

State should be explicit.
Recovery should be manual.
The window manager should remain vanilla.

This module keeps session control simple and predictable.
