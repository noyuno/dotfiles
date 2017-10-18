#!/bin/bash -e

jma()
{
    dfx sudo ufw allow 8000

    cat << EOF | sudo tee /etc/systemd/system/jmaws.service
[Unit]
Description=JMA disaster prevention information WebSocket server

[Service]
User=www-data
ExecStart=/var/www/html/jma/bin/run.sh

[Install]
WantedBy=multi-user.target
EOF

#    cat << EOF | sudo -u noyuno tee /var/www/html/jma/bin/run.sh
##!/bin/sh -e
#(
#    /usr/local/bin/python3 /var/www/html/jma/bin/websocket.py
#) >/dev/null
#EOF

    dfx sudo service jmaws restart
    dfx sudo systemctl enable jmaws

    # file remover

    cat << EOF | sudo tee /etc/cron.d/jmarm
25 */24 * * * www-data /var/www/html/jma/bin/rm.sh
EOF

#    cat << EOF | sudo -u noyuno tee /var/www/html/jma/bin/rm.sh
##!/bin/bash -e
#(
#    find /var/www/html/jma/data -ctime +3 -exec rm -f {} \;
#) >/dev/null
#EOF

    dfx sudo chmod +x /var/www/html/jma/bin/rm.sh

    dfx sudo touch /var/log/jma{,rm,ws}.log
    dfx sudo chown www-data:www-data /var/log/jma{,rm,ws}.log

}

