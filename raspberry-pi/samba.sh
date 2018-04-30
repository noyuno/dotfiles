#!/bin/bash -e

usage=$usage"
samba.sh
    samba: install samba"

samba() {
    sudo cp -f ~/dotfiles/raspberry-pi/smb.conf /etc/samba/smb.conf
    sudo systemctl restart smbd
}

