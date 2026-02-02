# Arch Linux Setup

This document describes the **base Arch Linux installation** used for this system.  
It focuses on disk layout, networking, and initial system bring-up.

The goal at this stage is:
- a clean bootable system
- working networking
- SSH access (optional)
- no desktop or audio stack yet

---

## 💽 Disk Layout

Partitioning was done manually using `fdisk`, verified with `lsblk`.

### Linux Partitions

| Mount Point | Filesystem | Flags / Notes |
|------------|-----------|---------------|
| `/boot/efi` | FAT32 | `boot`, `esp` |
| `/boot` | ext4 | no flags |
| `/` | ext4 | no flags |
| `/home` | btrfs | `linux-home` |

### Other Partitions

- **Windows EFI**: separate EFI partition (used for dual boot)
- **Backup partition**:  
  - 50 GB  
  - `exfat`  
  - not mounted by default

---

## 🌐 Connect to the Internet (Live ISO)

List network interfaces:

```bash
ip a
````

Example interface: `wlan0`

Scan available networks:

```bash
iwctl station wlan0 get-networks
```

Connect to a network:

```bash
iwctl --passphrase "network-password" station wlan0 connect "network-name"
```

---

## 🔐 Optional: Enable SSH (Work From Another System)

Install and start SSH on the live ISO:

```bash
pacman -Sy openssh
systemctl enable sshd
systemctl start sshd
passwd
ip a
```

From another system:

```bash
ssh root@<IP>
```

---

## ⚙️ Installation Method

* Installation performed using **`archinstall`**
* Disk partitioning done manually beforehand
* EFI mode (UEFI system)

### Disabled During Install

The following services were intentionally **disabled**:

* power management daemon
* PipeWire (audio)
* Bluetooth
* Printing

These will be configured later once X11 and the window manager are in place.

---

## ✅ Result

At the end of this stage:

* Arch Linux boots successfully
* Networking works
* Users and basic system config are complete
* No desktop environment or audio stack is installed yet
