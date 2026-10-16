# Dotfiles

My personal dotfiles and app configurations. These are focused on portability and minimalism for terminal-based development.

# Included Configs

- `.config/nvim/` – Neovim configuration
- `.bashrc` – Shell config
- `.gitconfig` – Git preferences
- `scripts/` – Useful CLI helpers
- `.zshrc`/ - z shell
- `.config/sway` - sway
- `.config/waybar` - waybar 
- `.config/rofi` - rofi
- `.config/tmux` - Tmux layout, plugins
- `.config/scripts` - all apps and sys scripts
- `.local/share/applications` - app launcher scripts .dekstop

# Setup

To install, clone the repo and run the `install.sh` script:

```bash
git clone https://github.com/slliks4/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

---

# 🧱 System Setup: Arch Linux Minimal + GRUB Fixes

## 🖥️ Base System

Start with a minimal Arch Linux install. You can follow the [official Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide), but here’s the gist:

## 🧰 GRUB Bootloader Setup

Install and configure GRUB for UEFI systems:

```bash
pacman -S grub efibootmgr os-prober
```

Mount your EFI partition (usually `/boot/efi`) before installing GRUB:

```bash
mkdir /boot/efi
mount /dev/sdX1 /boot/efi    # Replace sdX1 with your EFI partition
```

Install GRUB:

```bash
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
```

Generate config:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

✅ You should now have GRUB installed and ready.

---

---

# 🔧 Git, GitHub CLI, Dotfiles & AUR Helper Setup

## 🧬 1. Install Git + GitHub CLI

Install Git and the GitHub CLI (`gh`) to manage repositories and authenticate with GitHub easily:

```bash
sudo pacman -S git github-cli
```

✅ Once installed, you can authenticate using:

```bash
gh auth login
```

Follow the prompts to authenticate via your browser (recommended).

---

## 💼 2. Clone Dotfiles

Clone your dotfiles for configuration:

```bash
git clone https://github.com/slliks4/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

> 📝 Tip: If you use submodules, add `--recurse-submodules`.

---

## 🧰 3. Install AUR Helper: `paru`

### ✅ Why `paru`?

* Fast, minimal, and written in Rust
* Handles dependencies and `.SRCINFO` parsing well
* Cleaner prompts than `yay`

### 🛠 Setup Instructions

1. Install required build tools:

```bash
sudo pacman -S base-devel
```

2. Clone and build `paru`:

```bash
mkdir -p ~/aur && cd ~/aur
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

> ⚠️ Use `makepkg -si` instead of `paru` here since `paru` isn’t installed yet.

---

### 💡 `paru` Usage Examples

```bash
paru -S <package>     # install package
paru -Rns <package>   # remove package and unused deps
paru -Syu             # full system upgrade (AUR + repo)
```

> 🔍 Bonus: You can search AUR packages with `paru -Ss <keyword>`

---

## 🎨 GRUB Theme (Optional but nice)

To install a custom GRUB theme:

1. Clone a GRUB theme (e.g., [vimix-grub](https://github.com/slliks4/.dotfiles/grub-theme)):

```bash
git clone https://github.com/slliks4/.dotfiles/grub-theme
cd grub-theme
sudo ./install.sh 
```
Then regenerate GRUB:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## 🔍 Enable os-prober for Dual Booting

To detect other OSes (like Windows):

1. Edit `/etc/default/grub` and add:

```bash
GRUB_DISABLE_OS_PROBER=false
```

2. Then regenerate:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

## ⚠️ HP Firmware Quirk (GRUB not sticking)

HP systems often forcefully boot into `Windows Boot Manager`, ignoring GRUB.

### 💥 Workaround: EFI Loader Override Hack

1. Boot into Linux and run:

```bash
sudo mv /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi /boot/efi/EFI/Microsoft/Boot/bootmgfw_backup.efi
```

2. Then copy GRUB's loader in its place:

```bash
sudo cp /boot/efi/EFI/GRUB/grubx64.efi /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
```

3. Reboot.

🔄 Your system will now boot into GRUB first. Windows can still boot — it's just routed via GRUB.

✅ Don't forget to **restore** the original `bootmgfw.efi` file if you need to undo this change.

---

---

# 🎮 Install NVIDIA Drivers for Offloading

## 📦 Installation

```bash
sudo pacman -S nvidia-dkms nvidia-utils nvidia-prime linux-headers \
                libva libva-nvidia-driver nvidia-settings nvtop
```

### 📘 Notes:

1. **`nvidia-dkms`** – Rebuilds automatically on kernel updates (preferred over `nvidia`).
2. **`nvidia-utils`, `nvidia-prime`, `linux-headers`** – Required for offloading support.
3. **`libva`, `libva-nvidia-driver`** – Optional but improves VA-API (hardware acceleration).
4. **`nvidia-settings`, `nvtop`** – Optional for configuration and monitoring.

---

## ✅ Test Offloading

Check that offloading works with:

```bash
env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep "OpenGL renderer"
```

### ✅ Expected Output:

```text
OpenGL renderer string: NVIDIA ...
```

---

## 🧰 Enable NVIDIA DRM Kernel Mode Setting (for Wayland)

Edit:

```bash
sudo nano /etc/default/grub
```

Find:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
```

Replace with:

```bash
GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1"
```

### 🔁 Rebuild GRUB & Initramfs:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P
```

---

## 📊 Monitor dGPU Usage

```bash
nvidia-smi       # Basic info and GPU status
nvtop            # Live terminal GPU monitor
```

---

## 🚀 Run Apps with GPU Offloading

Use this pattern to launch apps on NVIDIA:

```bash
env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia appname
```

You can wrap this into app-specific scripts or `.desktop` launchers.

---

# 📉 Intel GPU Monitoring (if using hybrid graphics)

```bash
sudo pacman -S intel-gpu-tools
```

### 🖥 Usage:

```bash
sudo intel_gpu_top
```

> Useful if you want to monitor iGPU usage alongside `nvidia-smi`.

---

---

# 🖥️ Install Wayland Desktop Stack (Sway + Foot + Wofi)

## 📦 Install Core Packages

```bash
sudo pacman -S sway foot wofi swaybg
```

| Package  | Purpose                                            |
| -------- | -------------------------------------------------- |
| `sway`   | Wayland-based tiling window manager (i3-like)      |
| `foot`   | Lightweight terminal emulator for Wayland          |
| `wofi`   | Native app launcher (similar to rofi, but Wayland) |
| `swaybg` | Simple tool to set wallpapers in Sway              |

---

## ⌨️ Default Sway Keybindings

| Shortcut            | Action                         |
| ------------------- | ------------------------------ |
| `Super + Enter`     | Open terminal (`foot`)         |
| `Super + Shift + Q` | Close focused window           |
| `Super + [1–9]`     | Switch workspace               |
| `Super + Shift + C` | Reload config                  |
| `Super + H/J/K/L`   | Move between tiles (Vim-style) |

> 💡 All of these can be customized via `~/.config/sway/config`.

---

---

# Installing Core Functionality Before Personalizing Sway

Set up necessary system features for screen sharing, audio, brightness, clipboard, and UI elements before applying Sway-specific customization.

---

## 🎥 Screen Sharing on Wayland (with `xdg-desktop-portal-wlr`)

Enable screen sharing in Discord, Firefox, Chromium, and others under Wayland + Sway:

### ✅ Required Packages

```bash
paru -S xdg-desktop-portal-wlr xdg-desktop-portal xorg-xwayland slurp bemenu wofi
```

> **Notes**:
>
> * `slurp`, `bemenu`: Optional, only if `wofi` isn’t preferred
> * `wofi`: Recommended for Sway; Firefox tends to behave better with `wofi`

### 🧠 Enable Audio & Portal Services

```bash
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

---

### ⚙️ Picker Type (Optional Manual Override)

Create or edit:

```ini
~/.config/xdg-desktop-portal-wlr/config
```

Add:

```ini
[screen_cast]
picker_type=bemenu  # Or use wofi / slurp
```

Reload portal:

```bash
systemctl --user restart xdg-desktop-portal-wlr
```

---

### ✅ Verify Portal Is Running

```bash
busctl --user list | grep portal
```

Expected entries:

```
org.freedesktop.portal.Desktop
org.freedesktop.impl.portal.desktop.wlr
```

---

## 💡 Brightness Control (Laptop Only)

### 🔦 Install `light`

```bash
paru -S light
```

### 👤 Set Permissions

```bash
sudo tee /etc/udev/rules.d/90-backlight.rules > /dev/null <<EOF
ACTION=="add", SUBSYSTEM=="backlight", \
RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
EOF

sudo usermod -aG video $USER
```

> ⚠️ You must reboot for permissions to take effect.

### 📊 Usage:

```bash
light         # Show brightness (0-100%)
light -A 10   # Increase by 10%
light -U 10   # Decrease by 10%
```

---

## 🎧 Audio (PipeWire + Volume Control)

Ensure PipeWire is installed and volume is working:

```bash
sudo pacman -S pavucontrol
```

Use:

* `pavucontrol` for GUI control
* `wpctl`, `pamixer`, or `pactl` for CLI

---

## 🎨 Fonts & Utilities

Install UI fonts and terminal helpers:

```bash
sudo pacman -S ttf-font-awesome ttf-firacode-nerd htop
sudo pacman -S nerd-fonts
paru -S ttf-ms-fonts 
```
ttf-ms-fonts: Microsoft fonts for time new romans

These are needed for:

* Icons in Waybar
* Pretty prompt and terminal symbols
* Status modules and lock screens

---

## 🚀 Final Step: Reboot

```bash
sudo reboot
```

This ensures all user groups, permissions, and background services apply cleanly before continuing to Sway customization.

---

# 🎨 Customizing Sway

This section assumes you've already installed `sway`, `foot`, `wofi`, and `swaybg`. Now we're customizing the environment using dotfiles, scripts, and key UX tools.

---

## 1. 🌐 Application Launcher – Rofi (Optional)

```bash
paru -S rofi-wayland
```

> Your dotfiles include Rofi configuration at:

```
~/.config/rofi/config.rasi
~/.config/rofi/shared/colors.rasi
~/.config/rofi/shared/fonts.rasi
```

These files control launcher styling, theme colors, and font sizes using a CSS-like syntax.

---

## 2. 🔹 Status Bar – Waybar

Install and configure Waybar:

```bash
paru -S waybar
cd ~/dotfiles/waybar
sudo ./install.sh  # Or manually symlink to ~/.config/waybar
```

Key config files:

```
~/.config/waybar/config         # Layout & modules
~/.config/waybar/modules.json   # Custom logic
~/.config/waybar/style.css      # UI styling
~/.config/waybar/colors.css     # Color palette
```

Enable it via Sway config:

```ini
bar {
  swaybar_command waybar
}
```

---
## Screenshot
grim and slurp

script ~/.dotfiles/.config/scripts/sys/screenshot.sh

---
---
## Screen Record
wf-recorder
``` bash
sudo pacman -S wf-recorder
```

script ~/.dotfiles/.config/scripts/sys/screen_record.sh

---

---
## Desktop Notification

Recommended: mako 
Reason: Wayland native and follows the desktop notification specs

### Installation
``` bash
sudo pacman -S mako
sudo pacman -S libnotify
```

### Enable Mako in sway config (~/.config/sway/config)
```ini
# Start mako on login
exec mako
```

### Customizing mako (~/.dotfiles/.config/mako/config)
create symbolic link
``` bash
ln -s ~/.dotfiles/.config/mako ~/.config/mako
```

*** NOTE: The config file already contains some config and is well-commented easy to follow and understand

### Testing
``` bash
notify-send "Hello from Sway!" "Notifications are working 🎉"
```

---

## 3. 📀 Scripts Setup

Recommended layout:

```
~/.dotfiles/.config/scripts/sys/   # System logic (lock, idle, resize)
~/.dotfiles/.config/scripts/apps/  # App launchers (e.g., brave_social.sh)
```

Setup symlinks and permissions:

```bash
find ~/.dotfiles/.config/scripts -type f -exec chmod u+x {} +
ln -s ~/.dotfiles/.config/scripts ~/.config/scripts
```

---

## 4. 🔒 Lock Screen (swaylock-effects)

Install dependencies:

```bash
paru -S swaylock swayidle swaylock-effects
```

Lock script: `~/.config/scripts/sys/custom_lock_screen.sh` Auto lock script: `~/.config/scripts/sys/auto_lock_screen.sh`

Update Sway config:

```ini
exec bash ~/.config/scripts/sys/auto_lock_screen.sh
bindsym $mod+Escape exec ~/.config/scripts/sys/custom_lock_screen.sh
```

---

## 5. ❌ Logout Prompt

Script:

```bash
~/.config/scripts/sys/logout.sh
```

Bind to:

```ini
bindsym $mod+Shift+e exec ~/.config/scripts/sys/logout.sh
```

---

## 6. 🔄 Auto Resize Firefox Developer Tile

Script: `resize_profile.sh`

Stores toggle in:

```
~/.config/scripts/sys/.resize_status
```

Bind key:

```ini
bindsym $mod+y exec ~/.config/scripts/sys/resize_profile.sh
```

> Only Firefox is resized — avoids tiling changes to other windows.

---

## 7. 🧠 Load Sway Config from Dotfiles

```bash
ln -s ~/.dotfiles/.config/sway ~/.config/sway
```

> Sway config is modular and well-commented in your dotfiles.

---

## 🧩 Final Notes

* Minimal autostart; apps/scripts are launched only when needed.
* Every script is decoupled and easy to modify.
* Fully modular setup designed for efficient tiling, dev workflows, and reliability.

> ✅ You now have a complete, modular, and themed Wayland + Sway desktop environment optimized for development and productivity.
Here’s an added section at the end for clarity and friendliness:

---

## 💬 Documentation & Support

All scripts and configuration files in this setup are **well-commented** and organized for clarity. If you’re reading through the dotfiles:

* Pay attention to inline comments – they explain what each section does.
* Folder structure is intentional and mirrors how components are grouped (apps, system, visuals, etc.).

If you run into any issues or need help adapting the setup to your needs, **feel free to reach out** via GitHub or wherever this setup is shared.

> This system was built to be hackable and developer-friendly. Don’t be afraid to make it your own!

---


Here’s your cleaned-up and properly structured `README.md` for installing and configuring your apps. It's organized for clarity, with corrected spelling, formatting, and consistent markdown sections:

---

# 🎯 Personal App Setup Guide

A guide to installing and configuring the core applications I use. Most app-specific scripts are self-documented and can be found in the `scripts` directory or within the `.dotfiles`.

---

## 1. 💬 Discord (`.tar.gz` Setup with Wayland + Rich Presence)

### 📦 Why Not Use AUR?

* AUR packages often break due to mismatched Electron versions.
* Official `.tar.gz` includes a stable bundled Electron.
* Ensures:

  * Functional screen sharing
  * Rich Presence support
  * Stable minimized behavior

### 🛠 Installation

```bash
sudo pacman -S wget nss
wget -O ~/Downloads/discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz"
mkdir -p ~/opt/discord
tar -xzf ~/Downloads/discord.tar.gz -C ~/.local/bin/discord --strip-components=1
rm -r ~/Downloads/discord*.gz
```
*** Note you can always run update-discord on your terminal to make use of ~/.dotfiles/.local/bin/update-discord to automatically update discord

### 🖥 Create `.desktop` Launcher

```ini
[Desktop Entry]
Name=Discord
Exec=/home/YOUR_USERNAME/scripts/discord
Icon=/home/YOUR_USERNAME/.local/discord/discord.png
Type=Application
Categories=Network;Chat;
```

### 🔁 Update Instructions

Re-download and re-extract into `~/.local/discord`.

---

## 2. 🧱 Tmux

### 📦 Installation

```bash
sudo pacman -S tmux
```

### ⚙️ Setup

* Copy `.tmux.conf` from your `.dotfiles` to your home directory:

```bash
cp ~/.dotfiles/.tmux.conf ~/
```

### 🔌 Plugins (Session Save/Restore)

**Install TPM (Tmux Plugin Manager):**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

**Recommended Plugins:**

```bash
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.config/tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum ~/.config/tmux/plugins/tmux-continuum
```

💡 Plugin config is already included in your `.dotfiles/.config/tmux`.
in tmux you then source or reload, then prefix+Shift+I to install the plugins

🔗 Source: [https://github.com/tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)

---

## 3. 🌐 Browsers

Installed:

* `firefox-developer-edition`
* `firefox`
* `librewolf-bin`
* `falkon`

### 📜 Notes

* Firefox and Firefox Developer use custom launch scripts (see `scripts/apps`).
* `.desktop` entries are stored in `.local/share/applications`.
* Offloading to the dGPU is handled within the script (with comments).

---

## 4. 🐚 ZSH (Shell) and fzf

### 📦 Installation

```bash
sudo pacman -S zsh
sudo pacman -S fzf
```

### 🌀 Set ZSH as Default

```bash
chsh -s $(which zsh)
reboot
```

### ⚡ Install Oh My Zsh

```bash
wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh
```

### 🔌 Recommended Plugins
Check to see recommended setup
https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df

```bash
# Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Powerlevel10k theme
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

### 🛠 Setup

* Copy `.zshrc` from `.dotfiles` to your home directory:

```bash
cp ~/.dotfiles/.zshrc ~/
source ~/.zshrc
```

* Follow the Powerlevel10k configuration prompts.

### 🎨 Rice the Terminal

* Copy your `foot` config from `.dotfiles` to `.config`:

```bash
cp -r ~/.dotfiles/.config/foot ~/.config/
pkill foot
```

* Enable fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

*** This will install fzf with default Keybindings
next
``` bash
source ~/.zshrc
```

Reopen the terminal to apply changes.

---

## 5. 📝 Neovim

### 📦 Configuration

* Copy Neovim config from `.dotfiles`:

```bash
cp -r ~/.dotfiles/.config/nvim ~/.config/
```

### 📦 Install `packer.nvim`

```bash
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

### 🔁 Sync Plugins

Open Neovim and run:

```
:PackerSync
```

### 🔍 Requirement

Install `ripgrep` for search functionality:

```bash
sudo pacman -S ripgrep
```

---
✅ All scripts mentioned are well-commented and located in the `scripts/` folder for easy understanding.



# Installing packages for development
## 📦 Node.js + NVM Setup (for Zsh / Oh My Zsh)

### ✅ What is `nvm`?

`nvm` (Node Version Manager) is a tool that lets you:

* Install multiple versions of Node.js side-by-side
* Switch Node versions per project or globally
* Install global npm packages **without sudo**

> It's the safest, cleanest way to manage Node and npm for development.

---

## ⚠️ Why NOT use `sudo npm install -g`?

| Problem                                   | Explanation                                                                   |
| ----------------------------------------- | ----------------------------------------------------------------------------- |
| 🔐 Requires root                          | Global installs go to `/usr/lib/node_modules` (root-owned)                    |
| 🔥 Risk of breaking npm or other packages | Conflicts with your system's `pacman` or `dnf` package manager                |
| 🧼 Pollutes system space                  | You mix dev tools with system files                                           |
| 🔁 Updates break easily                   | Global tools installed with `sudo` can stop working after system/node updates |

---

## 🛠 How to Set Up `nvm` with Zsh

### 1. Install `nvm`

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

> This installs `nvm` to `~/.nvm`.

---

### 2. Add to `.zshrc` (Oh My Zsh compatible)

At the **bottom** of your `~/.zshrc`:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

Then reload Zsh:

```bash
source ~/.zshrc
```

---

### 3. Install Node

```bash
nvm install node      # latest version
nvm use node
```

You now have Node + npm fully in your home dir.

---

### 4. Use npm without sudo

```bash
npm install -g live-server sass
```

✔️ These go into `~/.nvm/.../lib/node_modules` — no permission issues.

---

### ✅ Confirm It's Working

```bash
which node
# → /home/yourname/.nvm/versions/node/vX.X.X/bin/node

npm list -g --depth=0
# Shows your global packages like live-server, sass, etc.
```
---
## 🔁 Notes
* You can install specific versions:
```bash
nvm install 18
nvm use 18
```
* You can set a default:
```bash
nvm alias default node
```
---
---
## Custom script for django (python manage.py runserver)
~/.dotfiles/.local/bin/dj
It is just a django automata for common django scripts like runserver and start project
run this to get started
```
dj
```
---
## Text to speach using pyttsx3
Best Option: pyttsx3
pyttsx3 is a cross-platform text-to-speech library that:
    Works offline
    Supports voice selection (male/female or multiple installed voices)
    Works on Windows, Linux, and macOS

For this to work you will need espeak-ng on linux 
sudo pacman -S espeak-ng  # (Arch/Manjaro)
you also need aplay from alsa-utils

sudo pacman -S alsa-utils

## Installing Night light
sudo pacman -S wlsunset
config automatically in sway using your longitude and lattitude
You can check this using 
```
curl https://ipinfo.io
```
exec wlsunset -l 47.5649 -L -52.7093 -t 4500

or toogle using night_light script in .config/sys/night_light.sh

## rsync
To copy everything in a directory **except the `.git` folder**, use the `rsync` command. Here's the most common and safe way:

```bash
rsync -av --exclude='.git' source_dir/ destination_dir/
```

### Breakdown:

* `rsync`: powerful file-copying tool.
* `-a`: archive mode (preserves permissions, symlinks, timestamps, etc.).
* `-v`: verbose output (optional).
* `--exclude='.git'`: tells rsync to skip the `.git` directory.
* `source_dir/`: the directory you want to copy from (trailing `/` is important).
* `destination_dir/`: where you want the contents copied to.

### Example:

```bash
rsync -av --exclude='.git' ./myproject/ ./backup/
```

This will copy all contents of `myproject` into `backup`, except the `.git` folder.

## KDE CONNECT
To Sync Device with System
```
sudo pacman -S kdeconnect
```
Note: Be on thesame network enable all the plugins

## Http Share for Screenshot
http-clipboard.sh in scripts/sys
