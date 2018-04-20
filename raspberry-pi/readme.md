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
    declare domain=noyuno.space
    declare mail=noyuno@$domain
    declare pdata=/var/postgresql/data
    declare showterm=/var/www/showterm

## Ports

- 25: postfix
- 80: nginx(public)
- 137: samba
- 138: samba
- 139: samba
- 143: dovecot IMAP
- 443: nginx(public)
- 587: postfix
- 4023: gitbucket
- 4040: pleroma
- 5432: postgre sql
- 8000: jma(public)
- 8080: gitbucket
- 8081: showterm
(- 8082: slack)
- 8125: netdata

