#!/bin/bash


export HYPRLAND_INSTANCE_SIGNATURE=$(/bin/ls $XDG_RUNTIME_DIR/hypr | grep -E '^[0-9a-f_]+$' | tail -n 1)

# Get active monitor resolution
monitor_info=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
width=$(echo "$monitor_info" | jq -r '.width')
height=$(echo "$monitor_info" | jq -r '.height')

# Get gaps from config
gaps_out=10
gaps_in=5

# Calculate usable space
usable_width=$((width - (gaps_out * 2)))
usable_height=$((height - (gaps_out * 2) - 32))  # 32 for waybar

# Calculate positions
half_w=$((usable_width / 2))
half_h=$((usable_height / 2))
quarter_w=$((usable_width / 2))
quarter_h=$((usable_height / 2))

case $1 in
  # Halves
  left-half)
    hyprctl dispatch moveactive exact $gaps_out $((gaps_out + 32))
    hyprctl dispatch resizeactive exact $half_w $usable_height
    ;;
  
  right-half)
    x=$((gaps_out + half_w + gaps_in))
    hyprctl dispatch moveactive exact $x $((gaps_out + 32))
    hyprctl dispatch resizeactive exact $half_w $usable_height
    ;;
  
  top-half)
    hyprctl dispatch moveactive exact $gaps_out $((gaps_out + 32))
    hyprctl dispatch resizeactive exact $usable_width $half_h
    ;;
  
  bottom-half)
    y=$((gaps_out + 32 + half_h + gaps_in))
    hyprctl dispatch moveactive exact $gaps_out $y
    hyprctl dispatch resizeactive exact $usable_width $half_h
    ;;
  
  # Quarters
  top-left)
    hyprctl dispatch moveactive exact $gaps_out $((gaps_out + 32))
    hyprctl dispatch resizeactive exact $quarter_w $quarter_h
    ;;
  
  top-right)
    x=$((gaps_out + quarter_w + gaps_in))
    hyprctl dispatch moveactive exact $x $((gaps_out + 32))
    hyprctl dispatch resizeactive exact $quarter_w $quarter_h
    ;;
  
  bottom-left)
    y=$((gaps_out + 32 + quarter_h + gaps_in))
    hyprctl dispatch moveactive exact $gaps_out $y
    hyprctl dispatch resizeactive exact $quarter_w $quarter_h
    ;;
  
  bottom-right)
    x=$((gaps_out + quarter_w + gaps_in))
    y=$((gaps_out + 32 + quarter_h + gaps_in))
    hyprctl dispatch moveactive exact $x $y
    hyprctl dispatch resizeactive exact $quarter_w $quarter_h
    ;;
  
  # Center (80% size)
  center)
    center_w=$((usable_width * 80 / 100))
    center_h=$((usable_height * 80 / 100))
    x=$(((width - center_w) / 2))
    y=$(((height - center_h) / 2))
    hyprctl dispatch moveactive exact $x $y
    hyprctl dispatch resizeactive exact $center_w $center_h
    ;;
esac

