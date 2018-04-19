#!/bin/bash -e

backup () {
cat << EOF | sudo tee /etc/cron.d/backup
35 04 * * * postgres /home/noyuno/dotfiles/raspberry-pi/pgdump
38 04 * * * root     /home/noyuno/dotfiles/raspberry-pi/etckeeper
EOF
    chmod -R 777 /mnt/karen/share/backup/psql
    sudo mkdir -p /root/.ssh
    sudo chmod 700 /root/.ssh
    sudo ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
    echo -e "Host git.noyuno.mydns.jp\n\tStrictHostKeyChecking no\n" | sudo tee -a /root/.ssh/config
    sudo chmod 600 /root/.ssh/config
}

