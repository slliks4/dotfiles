#!/bin/bash

# Path to the file that stores current toggle state
STATE_FILE="$HOME/.config/scripts/sys/.resize_status"

# Initialize toggle state if the file doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "expanded" > "$STATE_FILE"
fi

# Read the current state
STATE=$(cat "$STATE_FILE")

# Toggle resize state for Firefox
if [ "$STATE" = "expanded" ]; then
    swaymsg '[app_id="firefox-developer-edition"] focus'
    swaymsg resize set width 40 ppt
    echo "shrinked" > "$STATE_FILE"
else
    swaymsg '[app_id="firefox-developer-edition"] focus'
    swaymsg resize set width 60 ppt
    echo "expanded" > "$STATE_FILE"
fi

