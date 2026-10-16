#!/bin/bash

# Enable native Wayland support for Firefox Developer Edition
# "$@" allows passing any additional arguments from launchers or wofi
exec env MOZ_ENABLE_WAYLAND=1 firefox-developer-edition --name fdev "$@"

