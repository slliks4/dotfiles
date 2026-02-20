# Lock & Suspend (X11)

This module provides a minimal **lock + suspend** workflow using `slock`.

It is:

* window-manager agnostic
* fully manual (no lid hooks)
* dependency-light
* deterministic

---

## What This Module Does

* Locks the screen using `slock`
* Suspends the system after lock
* Installs `slock` automatically if missing
* Creates a `lock` command in `~/.local/bin`

No systemd user services.
No logind integration.
No background daemons.

---

## Installation

From the module directory:

```sh
./install.sh
```

This creates:

```text
~/.local/bin/lock
```

---

## Usage

Bind in `dwm` or run manually:

```sh
lock
```

This will:

1. Lock the screen
2. Suspend the system

---

## Philosophy

Power management should be:

* explicit
* predictable
* manual

This module exists so locking and sleeping remain under user control — without patches or hidden automation.
