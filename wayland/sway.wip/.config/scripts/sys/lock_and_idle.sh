#!/bin/bash
# set -euo pipefail

# # Path to swayidle PID storage
# PIDFILE="/tmp/swayidle-lockscreen.pid"

# # Start swayidle in background for suspend logic while locked
# swayidle \
#   timeout 2 'swaymsg "output * dpms off"' \
#   resume 'swaymsg "output * dpms on"' \
#   timeout 5 'systemctl suspend' \
#   before-sleep 'true' \
#   > /dev/null 2>&1 &

# echo $! > "$PIDFILE"

# # Run swaylock (blocks until user unlocks)
# swaylock --screenshots \
#   --clock \
#   --indicator \
#   --indicator-radius 150 \
#   --indicator-thickness 8 \
#   --effect-blur 7x5 \
#   --effect-vignette 0.5:0.5 \
#   --ring-color bb9af7 \
#   --key-hl-color 7aa2f7 \
#   --line-color 00000000 \
#   --inside-color 00000088 \
#   --separator-color 00000000 \
#   --fade-in 0.2 \
#   --timestr "%H:%M" \
#   --font "FiraCode Nerd Font" \
#   --datestr " %d %B"

# # When swaylock exits (user unlocked), kill swayidle
# if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
#     kill "$(cat "$PIDFILE")"
#     rm "$PIDFILE"
# fi
swaylock -f -c 00000000 &
sleep 1
systemctl suspend
