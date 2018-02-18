#!/bin/bash -e

python()
{
    #v=3.6.2
    #dfx wget -qO $HOME/Python-$v.tgz https://www.python.org/ftp/python/$v/Python-$v.tgz
    #pushd $HOME
    #    dfx tar xzf $HOME/Python-$v.tgz
    #    pushd $HOME/Python-$v/
    #        dfx ./configure
    #        dfx make -j4
    #        dfx sudo make install
    #    popd
    #popd

    dfx sudo apt install python3 python3-dev
    dfx sudo -H pip3 install watchdog tornado icalendar rpi.gpio pychromecast
}

