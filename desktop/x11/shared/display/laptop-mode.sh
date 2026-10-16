#!/usr/bin/env sh
set -e

# Disable all connected outputs
xrandr | grep " connected" | cut -d' ' -f1 | while read -r output; do
    xrandr --output "$output" --off
done

# Enable all connected outputs
xrandr --output eDP-1 \
    --mode 1366x768 \
    --rate 60 \
    --primary \
    --pos 0x0

# ==========================
# Wallpaper
# ==========================
WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"

if command -v feh >/dev/null 2>&1; then
    feh --bg-fill "$WALLPAPER_DIR/default.png"
fi

# ==========================
# Disable screen blanking + DPMS (MUST BE LAST)
# ==========================
xset s off
xset -dpms
xset s noblank
