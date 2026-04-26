#!/bin/bash
# Clipboard Screenshot - Share via HTTP for tablet access
# Usage: clipboard-screenshot [select] 
# Default: fullscreen

SHARE_DIR="/tmp/clipboard-screenshots"
PORT=8000

# Create temp directory
mkdir -p "$SHARE_DIR"

# Cleanup any existing files
rm -f "$SHARE_DIR"/*

case "$1" in
    select)
        echo "📐 Select area..."
        region=$(slurp) || exit
        grim -g "$region" "$SHARE_DIR/screenshot.png"
        ;;
    *)  # fullscreen
        grim "$SHARE_DIR/screenshot.png"
        ;;
esac

# Copy to local clipboard
wl-copy < "$SHARE_DIR/screenshot.png"

# Get local IP and create URL
LOCAL_IP=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+')
URL="http://$LOCAL_IP:$PORT/screenshot.png"

# Start HTTP server in background
cd "$SHARE_DIR"
python3 -m http.server $PORT > /dev/null 2>&1 &
SERVER_PID=$!

# Send URL to tablet clipboard via KDE Connect text sync
echo "$URL" | wl-copy

# Notify user
notify-send -t 6000 "📋📱" "Screenshot: Local clipboard + URL sent to tablet"

# Optional: Show QR code if available
if command -v qrencode >/dev/null 2>&1; then
    echo "📱 QR Code:"
    qrencode -t ansiutf8 "$URL"
fi

echo "✅ Screenshot ready:"
echo "   📋 Local clipboard: Ready to paste"
echo "   📱 Tablet: URL in clipboard - $URL"
echo "   ⏱️  Auto-cleanup on shutdown"

# Keep server running in background (until system shutdown)
# The /tmp cleanup will handle file deletion
disown $SERVER_PID
