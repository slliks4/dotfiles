# xrecord

Minimal screen recording utility for **X11 + dwm + Arch Linux**.

Built with:

* `ffmpeg`
* `slop`
* `libnotify`

No GUI.
No daemon.
No config files.
Just a clean toggle-based workflow.

---

## Features

* Region selection (like `maim -s`)
* Toggle start/stop recording
* Optional microphone support
* Notifications on start/stop
* Records to `~/Videos/Recordings`
* Install script included

---

## Dependencies

* `ffmpeg`
* `slop`
* `libnotify`
* `pulseaudio` (only if using mic)

Install manually:

```bash
sudo pacman -S ffmpeg slop libnotify pulseaudio
```

Or use the included installer.

---

## Installation

From the project directory:

```bash
chmod +x install.sh
./install.sh
```

This will:

* Install missing dependencies
* Create `~/Videos/Recordings`
* Symlink `xrecord` into `~/.local/bin`

---

## Usage

### Toggle screen recording

```bash
xrecord toggle
```

1. Select region.
2. Recording starts.
3. Run again to stop.

---

### Toggle screen + mic recording

```bash
xrecord toggle-mic
```

---

## Output

Recordings are saved to:

```
~/Videos/Recordings
```

Filename format:

```
YYYY-MM-DD_HH-MM-SS.mp4
```

---

## Example Keybinding (dwm)

In `config.h`:

```c
{ MODKEY|ShiftMask, XK_r, spawn, SHCMD("xrecord toggle") },
```
---

## Philosophy

This tool follows a simple design:

* One command
* One toggle
* Stateless except for PID file
* No background service
* Works directly with X11

It mirrors the Unix mindset:

> small tools, composed simply

---

## Troubleshooting

### Nothing records / black screen

Check you’re on X11:

```bash
echo $XDG_SESSION_TYPE
```

Should return:

```
x11
```

Also confirm:

```bash
echo $DISPLAY
```

---

### Mic not working

Check available sources:

```bash
pactl list short sources
```

Replace `default` in the script if needed.
