#!/usr/bin/env sh
set -e

PICOM_CONF="/home/scaramouche/.config/picom/picom.conf"
RULE="$1"

if [ -z "$RULE" ]; then
    echo "usage: add-opacity-rule \"rule\""
    exit 1
fi

mkdir -p "$(dirname "$PICOM_CONF")"
touch "$PICOM_CONF"

# If no block → create
if ! grep -q '^opacity-rule *= *\[' "$PICOM_CONF"; then
    cat >> "$PICOM_CONF" <<EOR

opacity-rule = [
    "$RULE"
];
EOR
    exit 0
fi

# If exists → skip
if grep -Fq "\"$RULE\"" "$PICOM_CONF"; then
    exit 0
fi

TMP_FILE="$(mktemp)"

while IFS= read -r line; do
    if [ "$line" = "];" ]; then
        echo "    \"$RULE\"," >> "$TMP_FILE"
    fi
    echo "$line" >> "$TMP_FILE"
done < "$PICOM_CONF"

mv "$TMP_FILE" "$PICOM_CONF"
