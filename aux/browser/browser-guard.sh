#!/usr/bin/env sh
set -e

THRESHOLD=$((3 * 1024 * 1024)) # 3GB in KB

check_and_kill() {
    name="$1"

    total=$(ps -o rss= -C "$name" 2>/dev/null | awk '{sum+=$1} END {print sum+0}')

    if [ "$total" -gt "$THRESHOLD" ]; then
        echo "$name using $((total / 1024)) MB → killing"
        pkill "$name"
    else
        echo "$name OK ($((total / 1024)) MB)"
    fi
}

check_and_kill zen-bin
check_and_kill firefox
check_and_kill qutebrowser
