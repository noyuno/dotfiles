#!/bin/bash -e
# https://qiita.com/tomkimra/items/be33bd27587d3c6eaca5

slack()
{
    dfx sudo npm install -g npm pnpm
    dfx sudo pnpm install -g n yo generator-hubot coffee-script
}

