#!/bin/bash -e

usage=$usage"
display.sh
    display: display resolution, rotation, calibration (Quimat 3.5) "

display()
{
    sudo cp /boot/config.txt ~/config.txt.old
    sudo cp ~/dotfiles/raspberry-pi/config.txt /boot/config.txt
    sudo cp ~/dotfiles/raspberry-pi/99-calibration.conf /etc/X11/xorg.conf.d/99-calibration.conf
}

export -f display

