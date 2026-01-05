#!/bin/bash
swww img $(find ~/github.com/circuit-shell/dotfiles/wallpapers/ -type f | shuf -n 1) \
  --transition-type center \
  --transition-fps 60 \
  --transition-duration 0.75 \
  --transition-angle 45
