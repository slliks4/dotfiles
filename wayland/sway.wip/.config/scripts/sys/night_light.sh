#!/bin/bash

if pgrep -x wlsunset > /dev/null; then
  pkill wlsunset
  notify-send "Night Light Off" "Blue light filtering disabled"
else
  wlsunset -T 6500 -t 3000 -S 12:00 -s 11:59 &
  notify-send "Night Light On" "Warm tint (3000k) applied"
fi
