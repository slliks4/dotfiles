#!/bin/bash
# Usage: screenshot full | select | copy

folder=~/Pictures/Screenshots
mkdir -p "$folder"
stamp=$(date +'%Y-%m-%d || %H:%M:%S').png
filepath="$folder/$stamp"

case "$1" in
  select)
    region=$(slurp) || exit
    grim -g "$region" "$filepath"
    ;;
  copy)
    grim - | wl-copy
    notify-send -t 1500 "📋 Screenshot copied to clipboard"
    exit
    ;;
  *)  # full
    grim "$filepath"
    ;;
esac

# launch swappy and auto-save back to the same file
swappy -f "$filepath" -o "$filepath" &

# optional slight delay before showing the notification
sleep 1
notify-send " Screenshot saved and opened in Swappy"
