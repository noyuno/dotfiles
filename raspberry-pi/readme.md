# Raspberry Pi 3 settings tool

[dotfiles](https://github.com/noyuno/dotfiles/blob/master/readme.md)

## Usage

    pi [commands]

commands

    install
    motd
    timezone
    ssl
    nginx
    psql
    gitbucket_psql
    kanboard_psql
    gitbucket
    gitbucket_nginx
    kanboard
    kanboard_nginx
    netdata
    netdata_conf
    netdata_nginx
    zeroconf
    pychromecast
    ddns
    anime
    showterm
    showterm_conf
    showterm_nginx
    cve
    vuls
    scan

If no command is given, will run below commands.

    install
    motd
    timezone
    ssl
    nginx
    psql
    gitbucket_psql
    kanboard_psql
    gitbucket
    gitbucket_nginx
    kanboard
    kanboard_nginx
    netdata
    netdata_conf
    netdata_nginx
    zeroconf
    pychromecast
    ddns
    anime
    showterm
    showterm_conf
    showterm_nginx
    cve
    vuls

## Variables

[`bin/pi`](https://github.com/noyuno/dotfiles/blob/master/bin/pi)

    declare user=noyuno
    declare gittarget=/var/git
    declare gituser=git
    declare domain=noyuno.mydns.jp
    declare mail=noyuno@$domain
    declare pdata=/var/postgresql/data
    declare showterm=/var/www/showterm

