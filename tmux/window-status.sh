#!/bin/bash -e

global=''
process='#W'
pwd=':#(pwd="#{pane_current_path}"; pwd=$(echo $pwd | sed "s|$HOME|~|"); echo ${pwd####*/})'

if [ $# -lt 2 ]; then
    echo "required least 2 arguments" >&2
    exit 1
fi
if [ $1 = "global" ]; then
    global='-g'
elif [ $1 = "nopwd" ]; then
    pwd=""
elif [ $1 != "normal" ]; then
    echo "missing argument 1" >&2
fi
if [ $2 = "prompt" ]; then
    process=''
elif [ $2 = "exec" ]; then
    process=':#W'
else
    process=':#[fg='$2']#W#[fg=white]'
fi

tmux set $global window-status-format '#[fg=white]#I'"$pwd$process"'#F#[default]'
tmux set $global window-status-current-format '#[fg=white,bg=blue,bold]#I'"$pwd$process"'#F#[default]'

