#!/bin/bash

# Launch Firefox with Wayland + dGPU offloading and custom Wayland app_id
exec env \
  MOZ_ENABLE_WAYLAND=1 \
  firefox --name media-firefox "$@"
