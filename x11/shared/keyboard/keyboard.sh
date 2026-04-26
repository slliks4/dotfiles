#!/usr/bin/env sh
set -e

# ==========================
# Keyboard configuration
# ==========================
# Caps Lock  -> Escape
# Shift+Caps -> Caps Lock
#
# Uses XKB option:
#   caps:escape_shifted_capslock
#
# Must run AFTER X starts (via conf.d)

# Key repeat (delay rate)
xset r rate 250 25

# Set layout and options (single source of truth)
setxkbmap -layout us -option '' -option caps:escape_shifted_capslock
