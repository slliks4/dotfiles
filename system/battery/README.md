# 🔋 Power Management

## Philosophy

Power management on this system is intentionally **simple, explicit, and boring**.

Instead of aggressive tuning or multiple overlapping tools, the setup relies on **power-profiles-daemon**, which integrates cleanly with modern Intel CPUs and automatically responds to AC and battery state changes.

The focus is on:

* minimal configuration
* zero conflicts
* explicit user intent
* easy long-term maintenance

Run `./install.sh` to install dependencies and symlink the battery-mode helper.

---

## GPU Configuration

### Intel iGPU

* Used exclusively for display and rendering
* Managed by the kernel with default runtime power management

### NVIDIA dGPU

* Present but intentionally unused
* No NVIDIA drivers installed

To make this explicit and prevent accidental activation, NVIDIA and Nouveau kernel modules are blacklisted at boot.

`/etc/modprobe.d/blacklist-nvidia.conf`

```conf
blacklist nouveau
blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
blacklist nvidia_uvm
```

After creating or modifying this file:

```bash
sudo mkinitcpio -P
```

---

## Power Management Stack

* **power-profiles-daemon** is used exclusively
* **TLP is not used**
* Profiles available:

  * `power-saver`
  * `balanced`
  * `performance`

Profiles are switched using `powerprofilesctl`.

---

## Dependencies

The `powerprofilesctl` CLI requires a Python GObject binding on Arch Linux.

```bash
sudo pacman -S power-profiles-daemon python-gobject
```

---

## Battery Mode Script

A small helper script is used to explicitly switch power profiles and adjust display brightness.

The script is intentionally stateless and does not override system power management logic.

### Script

`~/.local/bin/battery-mode`

```sh
#!/bin/sh

MODE="$1"

case "$MODE" in
    power-saver|powersave)
        powerprofilesctl set power-saver
        light -U 30 >/dev/null 2>&1
        notify-send "🔋 Power saver mode"
        ;;

    balanced)
        powerprofilesctl set balanced
        light -A 100 >/dev/null 2>&1
        notify-send "⚡ Balanced mode"
        ;;

    performance)
        powerprofilesctl set performance
        light -A 100 >/dev/null 2>&1
        notify-send "🚀 Performance mode"
        ;;

    *)
        echo "Usage: battery-mode {power-saver|balanced|performance}"
        exit 1
        ;;
esac
```

Make executable:

```bash
chmod +x ~/.local/bin/battery-mode
```

---

## Usage

Switch profiles manually:

```bash
battery-mode power-saver
battery-mode balanced
battery-mode performance
```

Check current profile:

```bash
powerprofilesctl get
```

Check brightness level:

```bash
light -G
```

---

## dwm Keybindings (example)

```c
{ MODKEY,           XK_p, spawn, SHCMD("battery-mode power-saver") },
{ MODKEY,           XK_b, spawn, SHCMD("battery-mode balanced") },
{ MODKEY|ShiftMask, XK_p, spawn, SHCMD("battery-mode performance") },
```

---

## Summary

* One power management daemon
* One script
* Explicit modes
* No background conflicts
* No hidden state

Power management should not be a project — this setup keeps it that way.

