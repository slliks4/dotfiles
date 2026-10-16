#!/bin/bash

TBT_PATH="/sys/bus/pci/devices/0000:00:0d.0"

# Unbind Thunderbolt controller
if [ -e "$TBT_PATH/driver/unbind" ]; then
  echo "0000:00:0d.0" > "$TBT_PATH/driver/unbind"
  sleep 1
  echo "0000:00:0d.0" > /sys/bus/pci/drivers_probe
fi

