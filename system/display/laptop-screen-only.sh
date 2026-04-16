# Disable all at first
xrandr --output HDMI-1 --off 2>/dev/null || true
xrandr --output DP-1 --off 2>/dev/null || true
xrandr --output eDP-1 --off 2>/dev/null || true

xrandr --output eDP-1 \
    --mode 1366x768 \
    --rate 60 \
    --primary \
    --pos 0x0

# ==========================
# Wallpaper
# ==========================

WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"
feh --bg-fill "$WALLPAPER_DIR/default.png"
