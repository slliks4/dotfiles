#!/bin/sh

# ==========================
# Display layout (explicit)
# ==========================

# HDMI_CONNECTED=0
# DP_CONNECTED=0

# if xrandr | grep -q "^HDMI-1 connected"; then
#     HDMI_CONNECTED=1
# fi
#
# if xrandr | grep -q "^DP-1 connected"; then
#     DP_CONNECTED=1
# fi

# Disable all at first
xrandr --output HDMI-0 --off 2>/dev/null || true
xrandr --output DP-0 --off 2>/dev/null || true
xrandr --output DP-2 --off 2>/dev/null || true

xrandr --output DP-0 \
    --mode 1920x1080 \
    --rate 165 \
    --pos 0x0 \
    --primary

xrandr --output DP-2 \
    --mode 1920x1080 \
    --rotate left \
    --left-of DP-0

xrandr --output HDMI-0 \
    --auto \
    --mode 1920x1080 \
    --right-of DP-0

# # --------------------------
# # Case 1: HDMI + DP connected
# # --------------------------
# if [ "$HDMI_CONNECTED" -eq 1 ] && [ "$DP_CONNECTED" -eq 1 ]; then
#     xrandr --output HDMI-1 \
#         --mode 1920x1080 \
#         --rotate left \
#         --pos 0x0
#
#     xrandr --output DP-1 \
#         --mode 1920x1080 \
#         --rate 165 \
#         --pos 1080x0 \
#         --primary
#
#     xrandr --output eDP-1 \
#         --mode 1366x768 \
#         --rate 60 \
#         --pos 3000x156
#
# # --------------------------
# # Case 2: DP only
# # --------------------------
# elif [ "$DP_CONNECTED" -eq 1 ]; then
#     xrandr --output DP-1 \
#         --auto \
#         --primary \
#         --pos 0x0
#
#     xrandr --output eDP-1 \
#         --mode 1366x768 \
#         --rate 60 \
#         --right-of DP-1
#
# # --------------------------
# # Case 3: HDMI only
# # --------------------------
# elif [ "$HDMI_CONNECTED" -eq 1 ]; then
#     xrandr --output HDMI-1 \
#         --auto \
#         --primary \
#         --pos 0x0
#
#     xrandr --output eDP-1 \
#         --mode 1366x768 \
#         --rate 60 \
#         --right-of HDMI-1
#
# # --------------------------
# # Case 4: Laptop only
# # --------------------------
# else
#     xrandr --output eDP-1 \
#         --mode 1366x768 \
#         --rate 60 \
#         --primary \
#         --pos 0x0
# fi
#
# # ==========================
# # DPI scaling (4K detection)
# # ==========================
#
# DPI=96
#
# # if xrandr | grep -q " connected.*3840x2160"; then
# #     DPI=150
# # fi
#
# CURRENT_DPI=$(xrdb -query | grep -i Xft.dpi | awk '{print $2}')
#
# if [ "$CURRENT_DPI" != "$DPI" ]; then
#     echo "Xft.dpi: $DPI" | xrdb -merge
# fi
#
# # ==========================
# # Wallpaper
# # ==========================

WALLPAPER_DIR="$HOME/.config/system/display/wallpaper"
feh --bg-fill "$WALLPAPER_DIR/default.png"
