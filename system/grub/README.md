# GRUB Setup

Minimal, reproducible GRUB setup for Arch Linux on UEFI systems.

Supports:
- Arch Linux
- Windows dual boot (same or separate EFI)
- multiple disks / multiple EFI partitions
- custom GRUB themes
- firmware fallback quirks

---

## Context

This step assumes:

- base system is installed
- EFI partition exists and is mounted at `/boot/efi`

If not, complete:

- `arch/README.md`

---

## 1. Install Required Packages

```bash
sudo pacman -Syu
sudo pacman -S grub efibootmgr os-prober
````

---

## 2. Mount EFI Partition

List EFI partitions:

```bash
lsblk -f | grep vfat
```

Verify mount:

```bash
findmnt /boot/efi
```

If not mounted:

```bash
sudo mount /dev/nvme0n1p1 /boot/efi
```

---

## Important

If multiple EFI partitions exist:

* GRUB must be installed to the partition mounted at `/boot/efi`
* do not mix EFI partitions across disks

Most boot issues come from this mismatch.

---

## 3. Mount Windows EFI (Optional)

If Windows uses a different EFI partition:

```bash
sudo mkdir -p /boot/efi/win-efi
sudo mount /dev/sdX1 /boot/efi/win-efi
```

Verify:

```bash
ls /boot/efi/win-efi/EFI/Microsoft/Boot
```

Expected:

```
bootmgfw.efi
```

---

## 4. Clean GRUB Installation

```bash
sudo rm -rf /boot/grub
sudo rm -rf /boot/efi/EFI/GRUB
```

Install:

```bash
sudo grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot/efi \
  --bootloader-id=GRUB \
  --recheck
```

---

## 5. Verify Installation

```bash
ls /boot/efi/EFI
```

Expected:

```
GRUB
Microsoft
BOOT
```

Check binary:

```bash
ls /boot/efi/EFI/GRUB/grubx64.efi
```

---

### If Missing

GRUB is installed incorrectly.

Re-run installation.

---

## 6. Enable OS Detection (Optional)

```bash
sudo nvim /etc/default/grub
```

Ensure:

```
GRUB_DISABLE_OS_PROBER=false
```

Generate config:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 7. Fix EFI Entries

List entries:

```bash
sudo efibootmgr -v
```

---

### Remove Broken Entries

```bash
sudo efibootmgr -b XXXX -B
```

---

### Create GRUB Entry

```bash
sudo efibootmgr -c \
  -d /dev/nvme0n1 \
  -p 1 \
  -L GRUB \
  -l '\EFI\GRUB\grubx64.efi'
```

---

### Set Boot Order

```bash
sudo efibootmgr -o GRUB_ID,WINDOWS_ID
```

---

## 8. Firmware Fallback

Some firmware ignores boot order.

Install fallback loader:

```bash
sudo grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot/efi \
  --removable
```

---

### Windows Override (Strict Firmware Fix)

Backup:

```bash
sudo mv /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi.bak
```

Replace:

```bash
sudo cp /boot/efi/EFI/GRUB/grubx64.efi \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi
```

---

### Restore (Optional)

```bash
sudo mv /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi.bak \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi
```

---

## 9. Theme Installation

From repository root:

```bash
cd grub
sudo ./install.sh
```

Themes are located in:

```
grub/themes/
```

---

## 10. Pre-Reboot Check

```bash
findmnt /boot/efi
ls /boot/efi/EFI
sudo efibootmgr -v
```

Ensure:

* `/boot/efi` is correct
* `/EFI/GRUB/grubx64.efi` exists
* GRUB entry is valid
* GRUB is first in BootOrder

---

## Common Failure

```
grub rescue>
```

Cause:

```
boot entry exists
but target file does not
```

Fix:

* reinstall GRUB
* verify EFI paths
* clean incorrect entries

---

## EFI Layout Reference

```
EFI
├─ EFI/GRUB/grubx64.efi
├─ EFI/Microsoft/Boot/bootmgfw.efi
└─ EFI/Boot/BOOTX64.EFI
```

---

## Rule

GRUB works only if:

```
boot entry → correct partition → correct file → file exists
```

---

## Next Step

Continue with system setup:

* `shared/system/README.md`
