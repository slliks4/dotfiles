#!/usr/bin/env sh
set -e

# ==========================
# Trackpad configuration (X11)
# ==========================
# - Enable tap-to-click
# - Enable natural scrolling
# - Use clickfinger method
# - Disable middle-button emulation

TRACKPAD="$(xinput list | grep -i 'touchpad' | awk -F'id=' '{print $2}' | cut -d' ' -f1)"

[ -z "$TRACKPAD" ] && exit 0

# Helper to safely set property
set_prop() {
    xinput set-prop "$TRACKPAD" "$@" 2>/dev/null || true
}

# Tap to click
set_prop "libinput Tapping Enabled" 1

# Natural scrolling
set_prop "libinput Natural Scrolling Enabled" 1

# Click method: clickfinger
set_prop "libinput Click Method Enabled" 0 1

# Disable middle-button emulation
set_prop "libinput Middle Emulation Enabled" 0
