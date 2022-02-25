#!/bin/bash

srcWindowIndex="$1"
srcWindowName=$(tmux display-message -t "$srcWindowIndex" -p "#W")
currentWindowName=$(tmux display-message -p "#W")

tmux join-pane -h -s "$srcWindowIndex" || exit 0
# tmux join-pane -s "$srcWindowIndex" || exit 0
# The index of left pane is 1.
tmux select-pane -t 1
tmux rename-window "$currentWindowName/$srcWindowName"
