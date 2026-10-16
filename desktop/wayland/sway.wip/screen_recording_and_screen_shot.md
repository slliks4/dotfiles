# Screen Recording & Screenshot Tools for Sway (Wayland)

Custom bash scripts for:

- **Screen recording** (with/without mic) using `wf-recorder`
- **Screenshot capture** (full/select/copy) and editing with `swappy`
- Notifications using Nerd Font icons and `notify-send` under `mako`

---

## 📦 Required Packages

Make sure the following packages are installed:

### Core Tools

| Tool         | Purpose                        | Install via    |
|--------------|--------------------------------|----------------|
| `wf-recorder`| Screen recording (Wayland)     | `pacman`       |
| `slurp`      | Region selection for screenshots/recording | `pacman` |
| `grim`       | Screenshot capture (Wayland)   | `pacman`       |
| `swappy`     | Annotate/edit screenshots      | `pacman`       |
| `wl-clipboard` | Clipboard integration (`wl-copy`, `wl-paste`) | `pacman` |
| `libnotify`  | Provides `notify-send`         | `pacman`       |
| `mako`       | Notification daemon (Wayland)  | `pacman`       |
| `ttf-nerd-fonts-symbols` (or a full Nerd Font like `ttf-jetbrains-mono-nerd`) | For glyph icons in notifications | `pacman` / `AUR` |

Install them all at once (if needed):

```bash
sudo pacman -S wf-recorder slurp grim swappy wl-clipboard libnotify mako
```

And install a Nerd Font:

```bash
yay -S ttf-jetbrains-mono-nerd
```

---

## 🖼 Screenshot Script

**Path:** `~/scripts/screenshot.sh`

**Usage:**

```bash
screenshot.sh full        # full screen screenshot
screenshot.sh select      # select a region
screenshot.sh copy        # screenshot to clipboard (no file)
```

- Saves screenshots to `~/Pictures/Screenshots`
- Opens the image in `swappy` for editing
- Shows system notifications using Nerd Font icons

---

## 🎬 Screen Recording Script

**Path:** `~/scripts/screen_record.sh`

**Usage:**

```bash
screen_record.sh toggle        # start/stop screen recording
screen_record.sh toggle-mic    # start/stop recording with mic
screen_record.sh stop          # force stop recording
```

- Saves recordings to `~/Videos/Recordings`
- Uses `wf-recorder` with optional region selection
- Sends `notify-send` popups (with icons)
- Mic recording uses the `-a` flag for `wf-recorder`

---

## 🔔 Notification Setup

Ensure you have `mako` installed and running.

Add this line to your Sway config:

```ini
exec mako
```

You can also customize `~/.config/mako/config` to use Nerd Fonts:

```ini
font=JetBrainsMono Nerd Font 10
default-timeout=2000
```

Restart mako:

```bash
pkill mako && mako &
```

---

## 🎨 Optional Enhancements

- Add binding in Sway config:
  ```ini
  bindsym $mod+Shift+s exec ~/scripts/screenshot.sh select
  bindsym $mod+Shift+r exec ~/scripts/screen_record.sh toggle
  ```
- Auto-upload screenshots or recordings
- Auto-copy file path after saving
- Use `ffmpeg` for post-processing if needed

---

## 📁 File Locations

- Screenshots: `~/Pictures/Screenshots`
- Recordings: `~/Videos/Recordings`
