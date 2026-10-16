#!/bin/bash

# Launch foot with a unique app_id for targeted Sway keybindings
exec env MOZ_ENABLE_WAYLAND=1 foot --app-id=scratch-terminal "$@"
