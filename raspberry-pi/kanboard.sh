#!/bin/bash -e

usage=$usage"
kanboard.sh
    kanboard: kanboard service
    kanboard_psql: psql for kanboard
    kanboard_nginx: nginx routing for kanboard "

kanboard_psql()
{
    cat << EOF | dfx sudo -u postgres psql
create database kanboard;
EOF
    dfx sudo -u postgres createuser --pwprompt --interactive kanban
}

kanboard()
{
    kp=/var/www/kanban
    if [ ! -e $kp ]; then
        dfx sudo wget -qO /tmp/kanboard.zip https://kanboard.net/kanboard-latest.zip
        dfx sudo unzip -od /var/www /tmp/kanboard.zip
        dfx sudo mv /var/www/kanboard $kp
        dfx sudo cp $kp/config.default.php $kp/config.php
    fi

    if [ ! -e $kp/plugins/Gantt ]; then
        dfx sudo wget -qO /tmp/kanboard-gantt.zip \
            https://github.com/kanboard/plugin-gantt/releases/download/v1.0.1/Gantt-1.0.1.zip
        dfx sudo mkdir -p $kp/plugins
        dfx sudo unzip -od $kp/plugins /tmp/kanboard-gantt.zip
    fi
    dfx sudo chown -R www-data:www-data $kp
}

kanboard_nginx()
{
    cat << EOF | sudo tee /etc/nginx/sites-available/kanboard.conf
server {
    listen 80;
    server_name kanban.$domain;
    charset UTF-8;
    root   /var/www/kanban;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /robots.txt {
        alias /var/www/html/robots-disallow.txt;
    }

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;

    location ~ \.php$ {
        root /var/www/kanban;
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/kanboard.conf \
        /etc/nginx/sites-enabled/kanboard.conf
    dfx sudo systemctl reload nginx.service

}

