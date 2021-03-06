#!/bin/bash

# git branch
cd $(tmux display-message -p -F "#{pane_current_path}")
branch_name=$(git branch | grep '*.*' | sed -e 's/\*\ //')
[ ! -z "$branch_name" ] && echo -n "(${branch_name}) "

# battery
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | \
    grep -e percentage -e 'time to empty' | \
    awk -F: '{print $2}' | \
    sed 's/\ \ //g'| \
    tr '\n' ' '

# date
cols=$(tmux list-windows|grep active|awk '{print $5}'|awk -Fx '{print $1}'|sed 's/\[//')
if [ "$cols" -gt 110 ]; then
    echo -n '['$(date '+%Y-%m-%d %H:%M')']'
fi

