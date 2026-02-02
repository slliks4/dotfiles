# GRUB SETUP

This document describes a **clean, reproducible GRUB setup** for Arch Linux on **UEFI systems**, including:

* Dual boot with Windows
* Separate EFI partitions (Arch + Windows)
* Custom GRUB themes
* Kernel default selection
* HP firmware quirks

This README reflects **real-world behavior**, not idealized docs.

---

## 🧰 Prerequisites

Update the system and install required packages:

```bash
sudo pacman -Syu
sudo pacman -S grub efibootmgr os-prober
```

---

## 📦 EFI Layout Assumptions

* Arch Linux EFI is mounted at:

  ```
  /boot/efi
  ```
* Windows EFI may be on a **different partition** and must be mounted separately for detection.

Verify current mounts:

```bash
findmnt /boot/efi
```

If Arch EFI is not mounted:

```bash
sudo mount /dev/nvme0n1p1 /boot/efi
```

(Adjust device name as needed.)

---

## 🔁 Clean GRUB Re-installation (Recommended)

If an old or incorrect GRUB install exists (e.g. stale EFI loaders), clean it first.

⚠️ **This does not touch Windows files.**

```bash
sudo rm -rf /boot/grub
sudo rm -rf /boot/efi/EFI/GRUB
```

Reinstall GRUB:

```bash
sudo grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot/efi \
  --bootloader-id=GRUB
```

---

## 🔍 Enable Windows Detection (Dual Boot)

`os-prober` **only detects Windows if the Windows EFI partition is mounted**.
On many OEM systems (including HP), Arch and Windows use **separate EFI partitions**.

---

### 1️⃣ Identify the Windows EFI partition

List EFI partitions:

```bash
lsblk -f | grep vfat
```

Look for the partition containing:

```text
EFI/Microsoft/Boot/bootmgfw.efi
```

---

### 2️⃣ Mount the Windows EFI partition

Create a mount point (once):

```bash
sudo mkdir -p /boot/efi/win-efi
```

Mount the Windows EFI partition:

```bash
sudo mount /dev/nvme0n1p5 /boot/efi/win-efi
```

Verify:

```bash
ls /boot/efi/win-efi/EFI/Microsoft/Boot
```

You should see `bootmgfw.efi`.

---

### 3️⃣ Enable OS detection in GRUB

Edit GRUB defaults:

```bash
sudo nvim /etc/default/grub
```

Ensure this line exists and is **uncommented**:

```text
GRUB_DISABLE_OS_PROBER=false
```

---

### 4️⃣ Regenerate GRUB configuration
**NOTE**: You can Skip this step and just install a theme first fromt the grub install as that also regenerates grub config

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Expected output:

```text
Found Windows Boot Manager
```

---

### 5️⃣ (Optional) Persist Windows EFI mount

To keep the Windows EFI always available:

```bash
sudo blkid /dev/nvme0n1p5
```

Add to `/etc/fstab`:

```text
UUID=<uuid>  /boot/efi/win-efi  vfat  defaults,noatime  0  2
```

---

## 🎨 Install a Custom GRUB Theme

Themes are managed via the dotfiles repository.

Clone the repo:

```bash
git clone https://github.com/slliks4/.dotfiles.git
cd .dotfiles/grub
```

Run the main installer:

```bash
sudo ./install.sh
```

### How the installer works

* Scans `themes/` for available themes
* Prompts for numbered selection
* Runs the selected theme’s `install.sh`
* Installs into `/boot/grub/themes/<theme>`
* Updates `GRUB_THEME` automatically

---

## 🧠 Kernel Default Fix (LTS Booting First)

If GRUB boots `linux-lts` by default, explicitly set the desired kernel.

Edit:

```bash
sudo nvim /etc/default/grub
```

Set:

```text
GRUB_DEFAULT="Advanced options for Arch Linux>Arch Linux, with Linux"
```

Apply changes:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## ⚠️ HP Firmware Quirk (Optional)

Some HP firmware **ignores GRUB** and always boots Windows Boot Manager.

### 💥 EFI Loader Override Workaround

Backup Windows bootloader:

```bash
sudo mv /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw_backup.efi
```

Replace it with GRUB:

```bash
sudo cp /boot/efi/EFI/GRUB/grubx64.efi \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi
```

Reboot.

> Firmware now loads GRUB first.
> Windows remains fully bootable via GRUB.

---

## 🔄 Restore Windows Bootloader (Undo)

```bash
sudo mv /boot/efi/EFI/Microsoft/Boot/bootmgfw_backup.efi \
        /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
```

---

## ⚠️ Theme Gotchas (Important)

* `theme.txt` **must** be at the theme root
* Paths inside `theme.txt` are **relative** and case-sensitive
* Fonts must be `.pf2`
* GRUB **fails silently** if assets are missing
* Do **not** nest themes inside extra directories
* Always regenerate GRUB after changes
* Do **not** edit `/boot/grub/grub.cfg` manually

---

## ✅ Final Verification Checklist

* GRUB loads on reboot
* Custom theme is visible
* Arch Linux (non-LTS) boots by default
* Windows entry is present and works
* EFI partitions mount cleanly

---

## 🧠 Notes

* Reboot safely unmounts EFI partitions automatically
* Forgetting to manually unmount EFI before reboot is safe
* This setup supports multiple GRUB themes cleanly
* Designed for long-term reuse on the same hardware

---

If you ever need to debug:

```bash
grep GRUB_THEME /etc/default/grub
ls /boot/grub/themes
```

---
