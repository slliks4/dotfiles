#!/usr/bin/env sh
set -e

slock &
sleep 0.5

exec systemctl suspend
