#!/bin/bash
hidapitester --vidpid 046D:C52B --usagePage 0xFF00 --usage 0x0001 --open --length 7 --send-output 0x10,0x02,0x0A,0x1E,0x01,0x00,0x00
if [ $? -eq 0 ]; then
    echo "✓ Switched to second device"
    notify-send "MX Master 3" "Switched to second device" -i input-mouse
else
    echo "✗ Failed to switch"
    exit 1
fi
