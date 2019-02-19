#!/bin/bash -e

. ~/dotfiles/bin/dffunc

unbound () {
    aptinstall unbound
    dfx sudo systemctl stop systemd-resolved
    dfx sudo systemctl disable systemd-resolved
    dfx sudo cp ~/dotfiles/server/unbound.conf /etc/unbound/unbound.conf.d/noyuno.jp.conf
    cat << EOF | sudo tee /etc/resolv.conf
nameserver 127.0.0.1
EOF
    dfx sudo systemctl enable unbound
    dfx sudo systemctl start unbound
}

unbound_updater () {
    cat << EOF | sudo tee /etc/cron.d/update-unbound
*/5 * * * * root /home/noyuno/dotfiles/server/update-unbound
EOF
}

