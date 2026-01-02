#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Master Mx: switch to second channel
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🖱️
# @raycast.packageName Logitech

# Documentation:
# @raycast.description Switch MX Master 3 to second channel
# @raycast.author spectr3r
# @raycast.authorURL https://github.com/spectr3r-system

sudo /usr/local/bin/hidapitester \
    --vidpid 046D:B023 \
    --usagePage 0xFF43 \
    --usage 0x0202 \
    --open \
    --length 20 \
    --send-output 0x11,0x00,0x0A,0x1E,0x01,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

if [ $? -eq 0 ]; then
    echo "✓ Switched to second device"
else
    echo "✗ Failed to switch"
    exit 1
fi
