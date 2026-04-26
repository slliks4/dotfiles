# Arch Linux — Base Installation

This document describes the minimal Arch Linux installation used for this system.

The goal of this stage is to produce a **clean, bootable base system**
with working networking and no unnecessary services.

At the end of this stage, the system will have:

- a working Arch Linux installation
- functional networking
- a bootloader-ready disk layout
- no desktop environment
- no audio stack

All additional components are configured in later modules.

---

## Disk Layout

Partitioning is performed manually.

```bash
fdisk /dev/sdX
````

Verify the result:

```bash
lsblk
```

Replace `sdX` with the correct device.

---

## Partition Scheme

| Mount Point              | Filesystem | Purpose                 |
| ------------------------ | ---------- | ----------------------- |
| `/boot/efi`              | FAT32      | UEFI firmware partition |
| `/boot`                  | ext4       | Kernel and boot files   |
| `/`                      | ext4       | Root filesystem         |
| `/home` *(optional)*     | btrfs      | User data               |
| `/devspace` *(optional)* | ext4       | Development workspace   |

---

## Partition Flags

Only one partition requires flags.

### EFI Partition

Must be set as:

* `EFI System`
* flags: `esp`, `boot`

This is required for UEFI firmware to detect the bootloader.

No other partitions require flags.

Do not set a boot flag on `/boot`.
This has no effect on UEFI systems.

---

## Formatting Partitions

Filesystems are created with labels.

Labels allow mounting by name instead of device path, avoiding issues
with changing device identifiers.

Example:

```bash
mount LABEL=root /mnt
```

---

### EFI

```bash
mkfs.vfat -F32 -n EFI /dev/sdX1
```

---

### Boot

```bash
mkfs.ext4 -L boot /dev/sdX2
```

---

### Root

```bash
mkfs.ext4 -L root /dev/sdX3
```

---

### Home (Optional)

```bash
mkfs.btrfs -L home /dev/sdX4
```

---

### Devspace (Optional)

```bash
mkfs.ext4 -L devspace /dev/sdX5
```

---

## Example Layout

```
Disk: /dev/nvme0n1

├─ nvme0n1p1   512M   EFI System       → /boot/efi
├─ nvme0n1p2   1G     Linux filesystem → /boot
├─ nvme0n1p3   150G   Linux filesystem → /
├─ nvme0n1p4   200G   btrfs            → /home
└─ nvme0n1p5   rest   ext4             → /devspace
```

---

## Networking (Live ISO)

Ethernet is typically configured automatically.

For Wi-Fi, use `iwctl`.

---

### Identify interface

```bash
ip a
```

---

### Scan networks

```bash
iwctl station wlan0 get-networks
```

---

### Connect

```bash
iwctl --passphrase "password" station wlan0 connect "network-name"
```

---

## Optional: SSH Access

SSH can be enabled to continue installation remotely.

See:

* `shared/dev/ssh/README.md`

---

## Services

No additional services are enabled at this stage.

The following are intentionally excluded:

* Bluetooth
* printing
* audio

These are configured later, depending on the chosen environment.

---

## Result

This stage produces:

* a minimal Arch Linux system
* working networking
* a predictable base environment

No display stack or user-level services are present.

---

## Next Step

Bootloader setup:

* `grub/README.md`
