#!/usr/bin/env sh
set -e

THRESHOLD=$((3 * 1024 * 1024)) # 3GB in KB

check_and_kill() {
    name="$1"

    total=$(ps -eo rss,comm | awk -v n="$name" '
        $2 == n { sum += $1 }
        END { print sum+0 }
    ')

    if [ "$total" -gt "$THRESHOLD" ]; then
        echo "$name using $((total / 1024)) MB → killing"

        case "$name" in
            qutebrowser)
                pkill -f qutebrowser
                pkill -f QtWebEngineProcess
                ;;
            *)
                pkill -f "$name"
                ;;
        esac
    else
        echo "$name OK ($((total / 1024)) MB)"
    fi
}

check_and_kill zen-bin
check_and_kill firefox
check_and_kill qutebrowser
