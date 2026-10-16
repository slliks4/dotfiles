#!/bin/sh

# ==========================
# Notification daemon (dunst)
# ==========================
# Lightweight X11 notification daemon
# Must run inside an active X session

# Kill existing instance (only exact match)
pkill -x dunst 2>/dev/null || true

# Start dunst in background and detach
nohup dunst >/dev/null 2>&1 &
