#!/bin/bash

LAYOUT=$(cat ~/github.com/dotfiles/tmux/layouts/7030/layout.txt)
tmux select-layout "$LAYOUT"
