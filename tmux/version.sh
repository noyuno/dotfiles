#!/bin/bash -e

verify_tmux_version () {
    tmux_home=~/dotfiles/tmux
    tmux_version="$(tmux -V | cut -d ' ' -f 2)"
    
    if [[ $(echo "$tmux_version >= 2.4" | bc) -eq 1 ]] ; then
        tmux source-file "$tmux_home/2.4.conf"
    else
        echo "not supported tmux $tmux_version"
        exit 1
    fi
}

verify_tmux_version
