#!/bin/bash -e

nodejs()
{
    dfx npm install -g n
    dfx export N_PREFIX=$HOME/.local
    dfx n lts
    dfx n use lts -v
}

export -f nodejs

