#!/bin/bash

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <channel>"
    echo "  channel: 1, 2, or 3"
    exit 1
fi

# Validate channel number
CHANNEL=$1
if [ "$CHANNEL" -lt 1 ] || [ "$CHANNEL" -gt 3 ]; then
    echo "Error: Channel must be 1, 2, or 3"
    exit 1
fi

# Convert to hex (channel 1 = 0x00, channel 2 = 0x01, channel 3 = 0x02)
HEX_CHANNEL=$(printf "0x%02X" $((CHANNEL - 1)))

echo "Switching MX Master 3 to channel $CHANNEL..."

sudo /usr/local/bin/hidapitester \
    --vidpid 046D:B023 \
    --usagePage 0xFF43 \
    --usage 0x0202 \
    --open \
    --length 20 \
    --send-output 0x11,0x00,0x0A,0x1E,$HEX_CHANNEL,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00

if [ $? -eq 0 ]; then
    echo "Successfully switched to channel $CHANNEL"
else
    echo "Failed to switch channel"
    exit 1
fi

