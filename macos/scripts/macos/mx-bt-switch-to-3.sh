#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title MX Bluetooth Channel 3
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖱️
# @raycast.packageName Logitech

# Documentation:
# @raycast.description Switch MX Master 3 to channel 3 (Bluetooth)
# @raycast.author spectr3r
# @raycast.authorURL https://github.com/spectr3r-system

sudo /usr/local/bin/hidapitester \
    --vidpid 046D:B023 \
    --usagePage 0xFF43 \
    --usage 0x0202 \
    --open \
    --length 20 \
    --send-output 0x11,0x00,0x0A,0x1E,0x02,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00 \
    > /dev/null 2>&1

if [ $? -eq 0 ]; then
    osascript -e 'display notification "Switched to channel 3" with title "MX Master 3 (BT)" sound name "Glass"'
fi
