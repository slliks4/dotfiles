#!/usr/bin/env sh

set -e

XRANDR_OUTPUT="$(xrandr)"

# ==========================
# Detect home setup
# ==========================
if echo "$XRANDR_OUTPUT" | grep -q "^DP-0 connected" && \
   echo "$XRANDR_OUTPUT" | grep -q "^DP-2 connected"; then

    echo "Home setup detected"

    # Disable all first
    echo "$XRANDR_OUTPUT" | grep " connected" | cut -d' ' -f1 | while read -r output; do
        xrandr --output "$output" --off
    done

    # Primary
    xrandr --output DP-0 \
        --mode 1920x1080 \
        --rate 165 \
        --pos 0x0 \
        --primary

    # Left monitor
    xrandr --output DP-2 \
        --mode 1920x1080 \
        --rotate left \
        --left-of DP-0

    # Optional clone (safe even if missing)
    if echo "$XRANDR_OUTPUT" | grep -q "^HDMI-0 connected"; then
        xrandr --output HDMI-0 \
            --same-as DP-0 \
            --auto
    fi

else
    echo "Fallback setup"

    # Generic: enable all connected outputs
    echo "$XRANDR_OUTPUT" | grep " connected" | cut -d' ' -f1 | while read -r output; do
        xrandr --output "$output" --auto
    done
fi

# ==========================
# Wallpaper
# ==========================
WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"

if command -v feh >/dev/null 2>&1; then
    feh --bg-fill "$WALLPAPER_DIR/default.png"
fi
