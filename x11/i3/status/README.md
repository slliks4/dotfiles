# i3status — Status Bar

This module installs and configures **i3status**.

It provides a minimal status bar for the i3 window manager.

---

## Scope

- installs `i3status`
- links configuration file

This module does **not**:

- configure i3 itself
- manage session startup
- install additional system utilities

---

## Installation

```bash
./install.sh
````

---

## Configuration

The configuration is managed from this module and symlinked to:

```bash
~/.config/i3status/config
```

---

## Usage

i3 will automatically use `i3status` if configured in the i3 config.

Example:

```bash
bar {
    status_command i3status
}
```

---

## Notes

* safe to re-run
* existing configs are backed up
* fully independent of other modules
