#!/bin/bash -e

service()
{
    services=(
        anime-ical
        anime-json
        bluetooth
        cron
        fcgiwrap
        gitbucket
        jmaws
        netdata
        nginx
        nmbd
        ntp
        php5-fpm
        postgresql
        showterm
        smbd
        ssh
        ufw)

    a=$(sudo systemctl list-units --type service)
    for service in ${services[@]}; do
        printf "%-20s" "$service"
        ret=$(sudo systemctl is-failed "$service") &&:
        case "$ret" in
            active)   echo -e "\e[32m$ret\e[m" ;;
            unknown)  echo -e "\e[31m$ret\e[m" ;;
            inactive) echo -e "\e[31m$ret\e[m" ;;
            unknown)  echo -e "\e[31m$ret\e[m" ;;
            *) echo "$ret Didn't match anything"
        esac
    done
}

