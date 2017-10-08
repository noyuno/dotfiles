#!/bin/bash -e

doctor()
{
    services=(anime-json anime-ical jmaws showterm nginx ssh netdata ntp php5-fpm postgresql nmbd gitbucket fcgiwrap cron bluetooth)
    a=$(sudo systemctl list-units --type service)
    for service in ${services[@]}; do
        printf "%-20s" "$service"
        echo $(sudo systemctl is-failed "$service" &&:)
    done
}

