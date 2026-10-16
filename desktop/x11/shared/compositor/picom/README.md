# Picom (X11 Compositor)

This module configures **picom** as the X11 compositor.

It provides:

- window transparency
- basic compositing support
- predictable rendering behavior

No visual effects or desktop-level enhancements are enabled.

---

## Scope

This module:

- enables transparency for selected applications
- applies opacity rules via a modular system
- ensures consistent rendering across the session

It intentionally avoids:

- blur
- shadows
- animations
- rounded corners

---

## Installation

```bash
./install.sh
````

---

## How It Works

The system is split into three layers:

### 1. Base configuration

```text
~/.config/picom/picom.base.conf
```

Contains static settings and an injection point:

```conf
opacity-rule = [
  # AUTO-GENERATED
];
```

---

### 2. Rule fragments

```text
~/.config/picom/conf.d/*.conf
```

Each module contributes rules such as:

```conf
"85:class_g = 'Alacritty'",
```

These are treated as fragments of a list.

---

### 3. Build step

```text
~/.config/picom/build.sh
```

This script:

* reads all files in `conf.d`
* injects them into the base config
* generates the final config:

```text
~/.config/picom/picom.conf
```

---

## Startup

Picom is started via the X11 session hook:

```text
~/.config/x11/conf.d/picom.sh
```

This script:

1. rebuilds the config
2. restarts picom

---

## Resync Support

Picom is integrated into:

```text
~/.local/bin/resync-session
```

Run:

```bash
resync-session
```

to:

* rebuild configuration
* restart picom
* apply new rules immediately

---

## Configuration

Minimal stable baseline:

```conf
backend = "glx";
vsync = true;
unredir-if-possible = false;

opacity-rule = [
  # AUTO-GENERATED
];
```

---

## Why Picom Is Needed

On X11, applications can request opacity, but cannot render it themselves.

Without a compositor:

* transparency is ignored
* all windows remain fully opaque

Picom enables this functionality with minimal overhead.

---

## Philosophy

The compositor should be:

* invisible
* predictable
* minimal
* explicitly configured

This module treats picom as a **rendering backend**, not a styling engine.

All behavior is:

* declarative (via `conf.d`)
* reproducible (via `build.sh`)
* manually applied (via `resync`)
