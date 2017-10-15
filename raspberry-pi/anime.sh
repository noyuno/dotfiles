#!/bin/bash -e

anime()
{
#    cat << EOF | sudo tee /etc/cron.d/anime
#19 */12 * * * $user /var/www/html/bin/anime
#EOF
    cat << EOF | sudo tee /etc/systemd/system/anime-ical.service
[Unit]
Description=Animation programs iCalendar service

[Service]
User=noyuno
ExecStart=/var/www/html/bin/anime-ical

[Install]
WantedBy=multi-user.target
EOF

    cat << EOF | sudo tee /etc/systemd/system/anime-json.service
[Unit]
Description=Animation programs JSON service

[Service]
User=noyuno
ExecStart=/var/www/html/bin/anime-json

[Install]
WantedBy=multi-user.target
EOF

    dfx sudo service anime-ical restart
    dfx sudo service anime-json restart
    dfx systemctl enable anime-ical
    dfx systemctl enable anime-json
}
export -f anime

