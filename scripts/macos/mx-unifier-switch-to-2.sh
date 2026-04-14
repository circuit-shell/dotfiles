#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title MX Channel Second
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖱️
# @raycast.packageName Logitech

# Documentation:
# @raycast.description Switch MX Master 3 to second device
# @raycast.author spectr3r
# @raycast.authorURL https://github.com/spectr3r-system

sudo /usr/local/bin/hidapitester \
    --vidpid 046D:C52B \
    --usagePage 0xFF00 \
    --usage 0x0002 \
    --open \
    --length 7 \
    --send-output 0x10,0x01,0x0A,0x1E,0x01,0x00,0x00 \
    > /dev/null 2>&1

if [ $? -eq 0 ]; then
    osascript -e 'display notification "Switched to second device" with title "MX Master 3" sound name "Glass"'
fi
