#!/bin/bash

# Get current brightness
current=$(ddcutil getvcp 10 | grep -oP 'current value =\s*\K[0-9]+')

# Handle the "up" or "down" argument
if [ "$1" == "up" ]; then
    new=$((current + 5))
    [ $new -gt 100 ] && new=100
    ddcutil setvcp 10 $new
elif [ "$1" == "down" ]; then
    new=$((current - 5))
    [ $new -lt 0 ] && new=0
    ddcutil setvcp 10 $new
fi

# Output the current/new value for Waybar to display
echo "{\"percentage\": $new}"
