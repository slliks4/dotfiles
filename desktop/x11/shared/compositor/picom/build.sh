#!/usr/bin/env sh
set -e

# ==========================
# Paths
# ==========================
CONFIG_DIR="$HOME/.config/picom"

BASE_CONFIG="$CONFIG_DIR/picom.base.conf"
FINAL_CONFIG="$CONFIG_DIR/picom.conf"
CONF_D_DIR="$CONFIG_DIR/conf.d"

# ==========================
# Validate base config
# ==========================
if [ ! -f "$BASE_CONFIG" ]; then
    echo "Missing base config: $BASE_CONFIG"
    exit 1
fi

# ==========================
# Build opacity rules
# ==========================
RULES=""

if [ -d "$CONF_D_DIR" ]; then
    for file in "$CONF_D_DIR"/*.conf; do
        [ -f "$file" ] || continue
        RULES="$RULES$(cat "$file")"$'\n'
    done
fi

# ==========================
# Generate final config
# ==========================
awk -v rules="$RULES" '
/# AUTO-GENERATED/ {
    print
    print rules
    next
}
{ print }
' "$BASE_CONFIG" > "$FINAL_CONFIG"

echo "Picom config rebuilt -> $FINAL_CONFIG"
