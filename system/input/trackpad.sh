#!/bin/sh

# ==========================
# Trackpad configuration (X11)
# ==========================
# - Enable tap-to-click
# - Enable natural scrolling
# - Use clickfinger method
# - Disable middle-button emulation

TRACKPAD="$(xinput list | grep -i 'touchpad' | sed 's/.*id=\([0-9]*\).*/\1/')"

[ -z "$TRACKPAD" ] && exit 0

# Tap to click
xinput set-prop "$TRACKPAD" "libinput Tapping Enabled" 1

# Natural scrolling (two-finger scroll)
xinput set-prop "$TRACKPAD" "libinput Natural Scrolling Enabled" 1

# Click method: clickfinger (L/R/M via fingers)
xinput set-prop "$TRACKPAD" "libinput Click Method Enabled" 0 1

# Disable middle-button emulation
xinput set-prop "$TRACKPAD" "libinput Middle Emulation Enabled" 0

