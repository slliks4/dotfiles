# GPU Firmware on system with dual gpu fix thunderbolt state not being cleared well resulting to weird screen glitches when using usb-c for display (thunderbolt)

## Create Reset thunder bolt script in /usr/local/bin
This script is used to reset the state of your thunderbolt controller
Steps:

### Check for Controller
``` Bash
lspci | grep -i thunderbolt
```
### Create you script and set TBT_PATH=your thunderbolt path
``` reset_thunderbolt.sh
#!/bin/bash

TBT_PATH="/sys/bus/pci/devices/0000:00:0d.0"

# Unbind Thunderbolt controller
if [ -e "$TBT_PATH/driver/unbind" ]; then
  echo "0000:00:0d.0" > "$TBT_PATH/driver/unbind"
  sleep 1
  echo "0000:00:0d.0" > /sys/bus/pci/drivers_probe
fi
```

### Make it Executable
``` Bash
sudo chmod +x /usr/local/bin/reset_thunderbolt.sh
```

### Create a systemd Shutdown Service(/etc/systemd/system/)
``` thunderbolt_reset.service
[Unit]
Description=Reset Thunderbolt controller before shutdown
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/bin/true
ExecStop=/usr/local/bin/reset_thunderbolt.sh
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target
```
### Enable the service
``` Bash
sudo systemctl enable thunderbolt_reset.service
```
