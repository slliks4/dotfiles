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

    # --------------------------
    # Update dwm status bar
    # --------------------------
    xsetroot -name "CPU $CPU | MEM $MEM | $BATTERY | $NET | $DATE $TIME"

    sleep "$INTERVAL"
done

