#!/usr/bin/env sh
set -e

# Lock screen
slock &

# Give slock time to grab input
sleep 0.5

# Suspend
systemctl suspend
