#!/bin/bash

LAYOUT=$(cat ~/github.com/dotfiles/tmux/layouts/2x3/layout.txt)
tmux select-layout "$LAYOUT"
