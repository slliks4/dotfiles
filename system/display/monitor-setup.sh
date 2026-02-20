#!/bin/sh

# ==========================
# Display layout (explicit)
# ==========================


# Disable all at first
xrandr --output HDMI-1 --off 2>/dev/null || true
xrandr --output DP-1 --off 2>/dev/null || true
xrandr --output eDP-1 --off 2>/dev/null || true

# Case 1: External DP monitor is present
if xrandr | grep -q "^DP-1 connected"; then

  # Portrait monitor (left)
  if xrandr | grep -q "^HDMI-1 connected"; then
    xrandr --output HDMI-1 \
      --mode 1920x1080 \
      --rotate left \
      --pos 0x0
  fi

  # Main external (center, primary)
  xrandr --output DP-1 \
    --mode 1920x1080 \
    --rate 165 \
    --pos 1080x0 \
    --primary

  # Laptop panel (right, vertically centered)
  xrandr --output eDP-1 \
    --mode 1366x768 \
    --rate 60 \
    --pos 3000x156

# Case 2: No external DP monitor (laptop only / event)
else
  # Laptop panel primary
  xrandr --output eDP-1 \
    --mode 1366x768 \
    --rate 60 \
    --pos 0x0 \
    --primary

  # If HDMI connected (event mode)
  if xrandr | grep -q "^HDMI-1 connected"; then
    xrandr --output HDMI-1 \
      --auto \
      --right-of eDP-1
  fi

fi

# ==========================
# Wallpaper (all monitors)
# ==========================
WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"
feh --bg-fill "$WALLPAPER_DIR/default.png"
