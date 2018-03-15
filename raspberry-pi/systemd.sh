#!/bin/bash -e

usage=$usage"
systemd.sh
    service: service status
    status: aliased for service "

service()
{
    services=(
        anime-ical
        anime-json
        bluetooth
        cron
        fcgiwrap
        gitbucket
        humidity
        jmaws
        netdata
        nginx
        nmbd
        ntp
        php5-fpm
        postgresql
        rsyslog
        showterm
        slack
        smbd
        ssh
        ufw
        )

    a=$(sudo systemctl list-units --type service)
    for service in ${services[@]}; do
        printf "%-20s" "$service"
        ret=$(sudo systemctl is-failed "$service") &&:
        case "$ret" in
            active)   echo -e "\e[32m$ret\e[m" ;;
            unknown)  echo -e "\e[31m$ret\e[m" ;;
            inactive) echo -e "\e[31m$ret\e[m" ;;
            failed)  echo -e "\e[31m$ret\e[m" ;;
            *) echo "$ret Didn't match anything"
        esac
    done
}

status()
{
    service
}

