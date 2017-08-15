#!/bin/bash -e

jma()
{
    dfx sudo ufw allow 8000

    cat << EOF | sudo tee /etc/systemd/system/jmaws.service
[Unit]
Description=Japan Meteorological Agency WebSocket Server

[Service]
User=www-data
ExecStart=/var/www/html/jma/server/run.sh

[Install]
WantedBy=multi-user.target
EOF

    cat << EOF | sudo -u noyuno tee /var/www/html/jma/server/run.sh
#!/bin/sh -e
(
    /usr/local/bin/python3 /var/www/html/jma/server/websocket.py
) >/dev/null 2>&1
EOF
    dfx sudo chmod +x /var/www/html/jma/server/run.sh
    dfx sudo service jmaws restart
}

