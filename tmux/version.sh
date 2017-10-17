#!/bin/bash -e

verify_tmux_version () {
    tmux_home=~/dotfiles/tmux
    tmux_version="$(tmux -V | cut -c 6-)"
    
    if [[ "$tmux_version" = "master" ]] ; then
        tmux source-file "$tmux_home/master.conf"
        exit
    elif [[ $(echo "$tmux_version >= 2.4" | bc) -eq 1 ]] ; then
        tmux source-file "$tmux_home/2.4.conf"
        exit
    else
        tmux source-file "$tmux_home/2.1.conf"
        exit
    fi
}

verify_tmux_version

