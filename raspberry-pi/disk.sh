#!/bin/bash -e

usage=$usage"
disk.sh
    spindown: spindown disk
"

spindown()
{
    cat << EOF | sudo tee /etc/systemd/system/spindown.service
[Unit]
Description=hdd spindown by sdparm
After=mnt-karen.mount

[Service]
ExecStart=/home/noyuno/dotfiles/raspberry-pi/spindown.sh sda 600
KillMode=process
Type=simple
Restart=no

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl enable spindown
    sudo systemctl start spindown
}

export -f spindown

