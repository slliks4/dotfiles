#!/bin/sh

# ==========================
# dwm status bar script
# ==========================

# --------------------------
# Dependency check
# --------------------------
if ! command -v xsetroot >/dev/null 2>&1; then
	echo "status.sh error: xsetroot not found."
	echo "Install it with: sudo pacman -S xorg-xsetroot"
	exit 1
fi

INTERVAL=2

while true; do
	# --------------------------
	# CPU usage
	# --------------------------
	CPU=$(awk '/^cpu / {
		usage=($2+$4)*100/($2+$4+$5)
		printf "%.0f%%", usage
	}' /proc/stat)

    # --------------------------
    # Memory usage
    # --------------------------
    MEM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

    # --------------------------
    # Battery (laptop-safe)
    # --------------------------
    if [ -d /sys/class/power_supply/BAT0 ]; then
	    BAT=$(cat /sys/class/power_supply/BAT0/capacity)
	    BATTERY="BAT ${BAT}%"
    else
	    BATTERY="AC"
    fi

    # --------------------------
    # Network (Ethernet / Wi-Fi)
    # --------------------------
    if ip link show | grep -q "state UP.*eth"; then
	    NET="ETH"
    elif [ -f /proc/net/wireless ] && grep -q ":" /proc/net/wireless; then
	    NET="WIFI"
    else
	    NET="OFF"
    fi

    # -------------------------- Date & time
    # --------------------------
    DATE=$(date "+%a %d %b")
    TIME=$(date "+%H:%M")

    VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print int($2 * 100)}')
    [ -n "$VOL" ] && VOL="VOL ${VOL}%" || VOL="VOL --"

    if [ -d /sys/class/backlight ]; then
	    BL=$(ls /sys/class/backlight | head -n1)
	    CUR=$(cat /sys/class/backlight/$BL/brightness)
	    MAX=$(cat /sys/class/backlight/$BL/max_brightness)
	    BRIGHT=$(awk "BEGIN {printf \"%.0f%%\", ($CUR/$MAX)*100}")
	    BRIGHT="BRI $BRIGHT"
    else
	    BRIGHT="BRI --"
    fi



    # --------------------------
    # Update dwm status bar
    # --------------------------
    xsetroot -name "CPU $CPU | MEM $MEM | $BATTERY | $NET | $VOL | $BRIGHT | $DATE $TIME"

    sleep "$INTERVAL"
done

