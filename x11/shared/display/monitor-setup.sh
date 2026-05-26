#!/usr/bin/env sh

set -e

XRANDR_OUTPUT="$(xrandr)"

disable_all_outputs() {
    echo "$XRANDR_OUTPUT" |
        grep " connected" |
        cut -d' ' -f1 |
        while read -r output; do
            xrandr --output "$output" --off
        done
}

# ==========================
# Start clean
# ==========================
disable_all_outputs

# ==========================
# Detect home setup
# ==========================
if echo "$XRANDR_OUTPUT" | grep -q "^DP-0 connected" && \
   echo "$XRANDR_OUTPUT" | grep -q "^DP-2 connected"; then

    echo "Home setup detected"

    # Primary
    xrandr --output DP-0 \
        --auto \
        --pos 0x0 \
        --primary

    # Left monitor
    xrandr --output DP-2 \
        --mode 1920x1080 \
        --rotate left \
        --left-of DP-0

    # Optional clone
    if echo "$XRANDR_OUTPUT" | grep -q "^HDMI-0 connected"; then
        xrandr --output HDMI-0 \
            --same-as DP-0 \
            --auto
    fi

else
    echo "Fallback setup"

    # ==========================
    # Laptop setup
    # ==========================
    if echo "$XRANDR_OUTPUT" | grep -q "^eDP-1 connected"; then

        xrandr --output eDP-1 \
            --auto \
            --primary

        if echo "$XRANDR_OUTPUT" | grep -q "^HDMI-1 connected"; then
            xrandr --output HDMI-1 \
                --auto \
                --left-of eDP-1
        fi

        if echo "$XRANDR_OUTPUT" | grep -q "^DP-1 connected"; then
            xrandr --output DP-1 \
                --auto \
                --right-of eDP-1
        fi

    # ==========================
    # Generic fallback
    # ==========================
    else
        echo "No eDP-1 detected -> enabling all displays"

        echo "$XRANDR_OUTPUT" |
            grep " connected" |
            cut -d' ' -f1 |
            while read -r output; do
                xrandr --output "$output" --auto
            done
    fi
fi

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
