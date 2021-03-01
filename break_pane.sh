#!/bin/bash

currentWindowIndex=$(tmux display-message -p "#I")
currentWindowName=$(tmux display-message -p "#W")

windowIndexes=$(tmux list-windows -F "#I")
# r: https://stackoverflow.com/questions/7442417/how-to-sort-an-array-in-bash
# IFS set new line as the delimiter.
windowIndexes=($(IFS=$'\n' sort -nr <<< "$windowIndexes"))
# no need to unset IFS, tmux use "bash break_pane.sh" to call this script.
# unset IFS

for windowIndex in "${windowIndexes[@]}"
do
    if [ "$windowIndex" -gt "$currentWindowIndex" ]
    then
        tmux move-window -d -s "$windowIndex" -t $((windowIndex+1))
    fi
done
# The index of right pane is 2.
tmux break-pane -s 2 -t $((currentWindowIndex+1))

# r: https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
IFS='/' read -ra panesName <<< "$currentWindowName"
leftPaneName=${panesName[0]}
rightPaneName=${panesName[1]}
tmux rename-window -t "$currentWindowIndex" "$leftPaneName"
tmux rename-window -t $((currentWindowIndex+1)) "$rightPaneName"

tmux select-window -t "$currentWindowIndex"

# r: https://unix.stackexchange.com/questions/21742/renumbering-windows-in-tmux
# reindex window
tmux move-window -r
