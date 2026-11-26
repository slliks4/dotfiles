encrypted partition
root and swap, with cryptsetup luks

Both using the same passphrase


| Stage | Purpose | What belongs there |
|---|---|---|
| **1. Prepare storage** | Make installation destinations available | Partitions, LUKS, filesystems, mounts, swap—already done |
| **2. Install minimal userspace** | Get an environment you can configure | `base`, then `arch-chroot` |
| **3. Make it bootable** | Start the installed system independently | Kernel, initramfs, LUKS unlocking, root mounting, `fstab`, bootloader |
| **4. Configure the system** | Establish its identity and users | Hostname, timezone, locales, passwords, user accounts |
| **5. Make it usable after boot** | Connect and work | graphics, window manager, applications |




Configure the system

## Creating user account
First install sudo

``` bash
pacman -S sudo
useradd -m -g users -G wheel youruser
passwd youruser
```
-g primary group
-G wheel add the user to supplementary wheel group
-m create /home/youruser dir

NOTE: you won't be able to ssh as root, you could easily change this in the sshd config under etc but it's advicable to create a user
READ DOCS

-  Enable sudo access for wheel
EDITOR=nvim visudo

Find and uncomment this line:
%wheel ALL=(ALL:ALL) ALL

This allows wheel members to run administrative commands after entering their own password. visudo checks the configuration’s syntax when you save.


**Yes—this is the system configuration stage:** locale, timezone and clock, then hostname.

Run these from your regular account using `sudo`. The examples use **Canadian English**, **St. John’s time**, and **`slliks4-laptop`**.

**1. Generate and select your locale**

Locale controls language, character encoding, and regional formatting.

```sh
sudo nvim /etc/locale.gen
```

Find and uncomment:

```text
en_CA.UTF-8 UTF-8
```

Then generate it and select it as the system default:

```sh
sudo locale-gen
sudo localectl set-locale LANG=en_CA.UTF-8
```

These are separate operations: **`locale-gen` builds the selected locale; `localectl` chooses which generated locale to use.** The default is stored in `/etc/locale.conf`. [ArchWiki](https://wiki.archlinux.org/title/locale?utm_source=chatgpt.com)

Log out and back in afterward so your session inherits the setting. Check with:

```sh
locale
```

**2. Configure timezone and clock synchronisation**

```sh
sudo timedatectl set-timezone America/St_Johns
sudo timedatectl set-ntp true
timedatectl
```

- `set-timezone` selects the local timezone, including daylight-saving rules.
- `set-ntp true` enables automatic network time synchronisation. [freedesktop.org](https://www.freedesktop.org/software/systemd/man/latest/timedatectl.html?utm_source=chatgpt.com)

Once the displayed time is correct and `System clock synchronized` says `yes`, write it to the hardware clock using UTC:

```sh
sudo hwclock --systohc --utc
```

The hardware clock keeps time while the laptop is off. **Store UTC there; Linux applies your timezone when displaying local time.** This also suits your planned Arch/Fedora setup. [ArchWiki](https://wiki.archlinux.org/title/Timedatectl?utm_source=chatgpt.com)

**3. Set the hostname**

This is the machine’s name, separate from your username:

```sh
sudo hostnamectl set-hostname slliks4-laptop
hostnamectl
```

Check local hostname resolution:

```sh
getent hosts slliks4-laptop
```

Arch’s default `nss-myhostname` setup normally handles this without a manual `/etc/hosts` entry. [ArchWiki](https://wiki.archlinux.org/index.php/Network_manager?utm_source=chatgpt.com)

Your configuration files now have distinct roles:

| File | Purpose |
|---|---|
| `/etc/locale.gen` | Locales to generate |
| `/etc/locale.conf` | Default locale |
| `/etc/localtime` | Selected timezone |
| `/etc/adjtime` | Hardware-clock settings |
| `/etc/hostname` | Persistent machine name |

**No GRUB or initramfs rebuild is needed for these changes.** Keyboard-layout changes affecting the LUKS prompt remain a separate step.
