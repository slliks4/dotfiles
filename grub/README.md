# GRUB Setup

Minimal, reproducible **GRUB setup for Arch Linux on UEFI systems**.

Supports:

* Arch Linux
* Windows dual boot
* Separate EFI partitions
* Custom GRUB themes
* Firmware fallback workaround

---

# 1. Install Required Packages

```bash
sudo pacman -Syu
sudo pacman -S grub efibootmgr os-prober
```

`os-prober` is required for Windows detection.

---

# 2. Mount EFI Partitions

### Arch EFI

Verify:

```bash
findmnt /boot/efi
```

If not mounted:

```bash
sudo mount /dev/nvme0n1p1 /boot/efi
```

---

### Windows EFI

If Windows uses a **separate EFI partition**, mount it before generating the GRUB config.

Identify EFI partitions:

```bash
lsblk -f | grep vfat
```

Create mount point:

```bash
sudo mkdir -p /boot/efi/win-efi
```

Mount Windows EFI:

```bash
sudo mount /dev/nvme0nxpx /boot/efi/win-efi
```

Verify:

```bash
ls /boot/efi/win-efi/EFI/Microsoft/Boot
```

You should see:

```
bootmgfw.efi
```

---

# 3. Clean GRUB Reinstallation (Recommended)

If GRUB was previously installed incorrectly, clean it first.

This **does not affect Windows**.

```bash
sudo rm -rf /boot/grub
sudo rm -rf /boot/efi/EFI/GRUB
```

Install GRUB:

```bash
sudo grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot/efi \
  --bootloader-id=GRUB
```

---

# 4. Enable Windows Detection

Edit GRUB defaults:

```bash
sudo nvim /etc/default/grub
```

Ensure:

```
GRUB_DISABLE_OS_PROBER=false
```

---

# 5. Generate GRUB Configuration

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Expected output:

```
Found Windows Boot Manager
```

> The theme installer in this repo also regenerates the GRUB config.

---

# 6. Install GRUB Theme

Themes are installed from the dotfiles repository.

```bash
git clone https://github.com/slliks4/.dotfiles.git
cd .dotfiles/grub
sudo ./install.sh
```

The installer:

* scans available themes
* installs selected theme
* updates `GRUB_THEME`
* regenerates GRUB config

---

# 7. Firmware Fallback Workaround

Many firmware implementations (HP, MSI, Dell, Lenovo, ASUS, etc.) may ignore the saved GRUB entry and boot **Windows Boot Manager** first.

UEFI defines a fallback loader at:

```
EFI/Boot/BootX64.efi
```

Copy GRUB there:

```bash
sudo mkdir -p /boot/efi/win-efi/EFI/Boot
sudo cp /boot/efi/EFI/GRUB/grubx64.efi \
        /boot/efi/win-efi/EFI/Boot/BootX64.efi
```

Temporarily move the Windows loader:

```bash
sudo mv /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi.bak
```

Reboot once.

Firmware will use the fallback loader, which now launches GRUB.

---

### Restore Windows Bootloader

After booting back into Arch:

```bash
sudo mv /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi.bak \
        /boot/efi/win-efi/EFI/Microsoft/Boot/bootmgfw.efi
```

Windows remains bootable through GRUB.

---

# Optional: Set Default Kernel

If GRUB boots `linux-lts` first:

```bash
sudo nvim /etc/default/grub
```

Example:

```
GRUB_DEFAULT="Advanced options for Arch Linux>Arch Linux, with Linux"
```

Regenerate config if needed:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

# Verify

After reboot:

* GRUB menu appears
* theme loads correctly
* Arch boots normally
* Windows entry works

---

## EFI Layout Reference

```
EFI
├─ EFI/GRUB/grubx64.efi
├─ EFI/Microsoft/Boot/bootmgfw.efi
└─ EFI/Boot/BootX64.efi   ← fallback loader
```
