#!/bin/bash -e
# https://qiita.com/tomkimra/items/be33bd27587d3c6eaca5

slack()
{
    sudo npm install -g npm n yo generator-hubot coffee-script
    sudo mkdir /var/slack
    sudo chown noyuno.noyuno /var/slack
    cd /var/slack
    yo hubot
}
