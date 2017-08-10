#!/bin/bash -e

cve()
{
    dfx sudo mkdir -p /var/log/vuls
    dfx sudo chown $user:$user /var/log/vuls
    dfx sudo chmod 700 /var/log/vuls
    if [ ! -e $GOPATH/src/github.com/labstack/echo ]; then
        mkdir -p $GOPATH/src/github.com/labstack
        dfx git clone https://github.com/labstack/echo $GOPATH/src/github.com/labstack/echo
        pushd $GOPATH/src/github.com/labstack/echo
            dfx git checkout 54a4d3140722793aa1cc430bd8a4a73aedff2783
        popd
    fi
    dfx go get github.com/kotakanbe/go-cve-dictionary
    dfx sudo mkdir -p /var/vuls
    dfx sudo chown $user:$user /var/vuls
    #for i in `seq 2002 $(date +"%Y")`; do
    #    dfx go-cve-dictionary fetchnvd -dbpath=/var/vuls/cve.sqlite3 -years $i
    #done
    dfx go-cve-dictionary fetchnvd -dbpath=/var/vuls/cve.sqlite3 -last2y
}

vuls()
{
    dfx mkdir -p $GOPATH/src/github.com/future-architect
    [ ! -e $GOPATH/src/github.com/future-architect ] && \
        dfx git clone https://github.com/future-architect/vuls.git \
        $GOPATH/src/github.com/future-architect/vuls
    if ! which vuls; then
        pushd $GOPATH/src/github.com/future-architect/vuls
            dfx make install
        popd
    fi
    cat << EOF | sudo tee /etc/sudoers.d/400_vuls
vuls ALL=(ALL) NOPASSWD: /usr/bin/apt-get update
Defaults:vuls env_keep="http_proxy https_proxy HTTP_PROXY HTTPS_PROXY"
EOF
}

scan()
{
    cat << EOF | tee /var/tmp/vuls-config.toml
[servers]

[servers.localhost]
host        = "localhost"
port        = "local"
EOF
    mkdir -p /var/tmp/vuls.results
    #dfx vuls configtest -config=/tmp/vuls-config.toml
    dfx vuls scan -config=/var/tmp/vuls-config.toml -cachedb-path /var/tmp/vuls-cache.db \
        -results-dir=/var/tmp/vuls.results
    dfx vuls report -format-short-text -config=/var/tmp/vuls-config.toml \
        -cvedb-path=/var/vuls/cve.sqlite3 -results-dir=/var/tmp/vuls.results
}

export -f cve
export -f vuls
export -f scan

