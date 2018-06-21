#!/bin/bash -e

usage=$usage"
nodejs.sh
    nodejs: nodejs "

nodejs()
{
    sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo bash -
    dfx sudo apt install -y nodejs
    [ ! -f /usr/bin/node ] && dfx sudo ln -sfnv /usr/bin/nodejs /usr/bin/node
    dfx sudo npm install -g n
    dfx sudo n lts
    dfx sudo n use lts -v
}

export -f nodejs

