# Arch Linux — Base Installation

This document describes the **minimal Arch Linux installation** used for this system.

The purpose of this stage is to produce a **clean, bootable base system** with networking working and no unnecessary services installed.

At the end of this stage the system will have:

* a working Arch Linux installation
* functional networking
* a bootloader-ready disk layout
* no desktop environment
* no audio stack

Everything else is configured later in separate modules.

---

# Disk Layout

Partitioning was performed manually using `fdisk`.

```bash
fdisk /dev/sdX
```

Verify the layout afterwards:

```bash
lsblk
```

Replace `sdX` and partition numbers with the correct values for your disk.

---

# Partition Scheme

| Mount Point              | Filesystem | Purpose                      |
| ------------------------ | ---------- | ---------------------------- |
| `/boot/efi`              | FAT32      | UEFI firmware boot partition |
| `/boot`                  | ext4       | Kernel and bootloader files  |
| `/`                      | ext4       | Root filesystem              |
| `/home` *(optional)*     | btrfs      | User data                    |
| `/devspace` *(optional)* | ext4       | Development workspace        |

---

# Partition Flags (Important)

Only **one partition requires flags**.

### EFI Partition

The EFI partition must have:

* `esp`
* `boot`

Example using `fdisk`:

```
Type: EFI System
```

This is required for **UEFI firmware to detect the bootloader**.

No other partitions require flags.

Common mistake:

People often try to set a **boot flag on `/boot`**.
This is **not required** and has no effect on modern UEFI systems.

---

# Formatting Partitions

After partitioning, create filesystems.

### EFI Partition

```bash
mkfs.vfat -F32 /dev/sdX1
```

---

### Boot Partition

```bash
mkfs.ext4 /dev/sdX2
```

---

### Root Partition

```bash
mkfs.ext4 /dev/sdX3
```

---

### Home Partition (Optional)

```bash
mkfs.btrfs /dev/sdX4
```

Used to isolate user files from the system.

---

### Development Partition (Optional)

```bash
mkfs.ext4 /dev/sdX5
```

Used for development environments or large project files.

---

# Networking (Live ISO)

Ethernet connections usually work automatically.

For Wi-Fi connections use `iwctl`.

---

### List interfaces

```bash
ip a
```

Example wireless interface:

```
wlan0
```

---

### Scan for networks

```bash
iwctl station wlan0 get-networks
```

---

### Connect to a network

```bash
iwctl --passphrase "password" station wlan0 connect "network-name"
```

---

# Optional: Enable SSH

SSH can be enabled to complete the installation from another machine.

SSH setup instructions are located here:
- [../dev/ssh/README.md](../dev/ssh/README.md)

---

# Services Not Enabled Yet

The following services are intentionally **not enabled** during base installation:

* Bluetooth
* Printing
* Audio services

These will be configured later alongside the **window manager and desktop stack**.

---

# Result

At this stage the system provides:

* a **minimal Arch Linux environment**
* working networking
* a **clean base system**
* no desktop environment
* no unnecessary background services

This keeps the system predictable and easy to build on.

---

# Next Step

Bootloader setup.

```
../grub/README.md
```

---

**disk diagram**

Example:

```
Disk: /dev/nvme0n1

├─ nvme0n1p1   512M   EFI System       → /boot/efi
├─ nvme0n1p2   1G     Linux filesystem → /boot
├─ nvme0n1p3   150G   Linux filesystem → /
├─ nvme0n1p4   200G   btrfs            → /home
└─ nvme0n1p5   rest   ext4             → /devspace
```
