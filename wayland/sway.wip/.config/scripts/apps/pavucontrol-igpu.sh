#!/bin/bash
# Run pavucontrol without dGPU variables
unset __NV_PRIME_RENDER_OFFLOAD
unset __GLX_VENDOR_LIBRARY_NAME
unset __VK_LAYER_NV_optimus
exec pavucontrol "$@"
