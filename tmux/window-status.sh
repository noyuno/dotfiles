#!/bin/bash -e

global=''
process='#W'
pwd='#(pwd="#{pane_current_path}"; pwd=$(echo $pwd | sed "s|$HOME|~|"); echo ${pwd####*/}):'

if [ $# -eq 0 ]; then
    echo "required least 1 argument" >&2
    exit 1
fi
if [ $1 = "global" ]; then
    global='-g'
elif [ $1 = "nopwd" ]; then
    pwd=""
fi
if [ $# -eq 2 ]; then
    echo $2
    process='#[fg='$2']#W#[fg=white]'
fi

tmux set $global window-status-format '#[fg=white]#I:'"$pwd$process"'#F#[default]'
tmux set $global window-status-current-format '#[fg=white,bg=blue,bold]#I:'"$pwd$process"'#F#[default]'

