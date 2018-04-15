#!/bin/bash -e

samba() {
    sudo cp -f ~/dotfiles/raspberry-pi/smb.conf /etc/samba/smb.conf
    sudo systemctl restart smbd
}

