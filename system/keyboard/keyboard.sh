#!/bin/sh

# ==========================
# Keyboard configuration
# ==========================
# Caps Lock  -> Escape
# Shift+Caps -> Caps Lock
#
# Uses XKB option:
#   caps:escape_shifted_capslock
#
# This must be applied AFTER X starts.

setxkbmap -option '' \
           -option caps:escape_shifted_capslock
