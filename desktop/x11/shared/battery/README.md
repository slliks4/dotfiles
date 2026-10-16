# Battery (Power Management)

This module provides **basic power management utilities** for X11 systems.

It is designed to be:

- minimal
- explicit
- predictable
- easy to maintain

---

## Scope

This module provides:

- a `battery-mode` helper for switching power profiles
- a `battery-notify` script for low battery notifications

It avoids:

- complex tuning tools (e.g. TLP)
- overlapping daemons
- automatic policy conflicts

---

## Installation

```bash
./install.sh
````

---

## What This Module Does

### 1. Power Profiles

Uses:

```text
power-profiles-daemon
```

Available profiles:

* `power-saver`
* `balanced`
* `performance`

Switching is handled manually via:

```bash
battery-mode <profile>
```

---

### 2. Battery Notifications

A background script:

```text
~/.local/bin/battery-notify
```

* monitors battery level
* sends notifications at defined thresholds

---

## How It Works

### Scripts

Installed to:

```text
~/.local/bin/
```

* `battery-mode`
* `battery-notify`

````

---

### X11 Integration

The module installs a hook:

```text
~/.config/x11/conf.d/battery.sh
````

This runs at X session startup:

```sh
battery-notify &
```

---

### Resync Support

The module is integrated into:

```text
~/.local/bin/resync-session
```

Run:

```bash
resync-session
```

to restart battery monitoring if needed.

---

## Dependencies

Handled automatically by `install.sh`:

* `power-profiles-daemon`
* `light`
* `libnotify`
* `python`
* `python-gobject`

---

## Usage

### Switch power mode

```bash
battery-mode power-saver
battery-mode balanced
battery-mode performance
```

---

### Check current mode

```bash
powerprofilesctl get
```

---

### Check brightness

```bash
light -G
```

---

## Philosophy

Power management should be:

* simple
* explicit
* user-controlled
* free of hidden behavior

This module provides only the essentials and avoids turning power management into a system-wide tuning project.
