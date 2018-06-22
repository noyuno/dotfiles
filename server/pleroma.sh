#!/bin/bash -e

usage=$usage"
pleroma.sh
    pleroma: install pleroma
    pleroma_repo: clone repo
    pleroma_nginx: nginx setting"

pleroma () {
    echo "deb https://packages.erlang-solutions.com/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
    dfx wget -qO /tmp/key.asc https://packages.erlang-solutions.com/debian/erlang_solutions.asc
    dfx sudo apt-key add erlang_solutions.asc
    dfx sudo apt update
    aptinstall elixir erlang erlang-xmerl
#mix deps.get
#mix generate_config
#sudo su postgres -c 'psql -f config/setup_db.psql'

    #sudo -u pleroma mkdir -p /var/pleroma/.config.systemd/user
    #cat << EOF | sudo -u pleroma tee /var/pleroma/.config/systemd/user/pleroma.service
    cat << EOF | sudo tee /etc/systemd/system/pleroma.service
[Unit]
Description=Pleroma social network
After=network.target postgresql.service

[Service]
User=pleroma
WorkingDirectory=/var/pleroma/pleroma
Environment="MIX_ENV=prod"
ExecStart=/usr/local/bin/mix phx.server
StandardOutput=syslog
SyslogIdentifier=pleroma
ExecReload=/bin/kill $MAINPID
KillMode=process
Restart=on-failure
RestartSec=15s
StartLimitBurst=5

[Install]
WantedBy=multi-user.target
Alias=pleroma.service
EOF
}

pleroma_repo() {
    sudo -u pleroma git clone https://git.pleroma.social/noyuno/pleroma.git
    sudo -u pleroma git clone https://github.com/noyuno/dotfiles.git
    sudo -u pleroma git clone https://github.com/noyuno/pleromabot.git
}

pleroma_nginx () {

    cat << EOF | sudo tee /etc/nginx/sites-available/pleroma.conf
proxy_cache_path /tmp/pleroma-media-cache levels=1:2 keys_zone=pleroma_media_cache:10m max_size=10g
    inactive=720m use_temp_path=off;

#upstream pleroma-backend {
#    # the pleroma backend
#    server 127.0.0.1:4040;
#    keepalive 64;
#}

server {
    listen         80;
    server_name    s.$domain;
    $upgrade
}

server {
    listen 443 ssl http2;
    ssl on;
    ssl_session_timeout 5m;

    $certfile

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
    ssl_prefer_server_ciphers on;

    server_name s.$domain;
    error_page 503 /503;
    error_page 502 =503 /503;

    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript application/activity+json application/atom+xml;

    client_max_body_size 16m;

    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;

    location / {
        # if you do not want remote frontends to be able to access your Pleroma backend
        # server, remove these lines.
        if (\$request_method = OPTIONS) {
            return 204;
        }
        # stop removing lines here.

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$http_host;

        proxy_pass http://localhost:4040;

        client_max_body_size 16m;

    }

    location /503 {
        root /var/www/html/pleroma;
        try_files /503.html /;
    }
    location ~ ^/(about/more|terms) {
        root /var/www/html/pleroma;
        try_files /about.html /;
    }

    location /proxy {
        proxy_cache pleroma_media_cache;
        proxy_cache_lock on;
        proxy_pass http://localhost:4040;
    }
}
EOF

    dfx sudo ln -sfnv /etc/nginx/sites-available/pleroma.conf \
        /etc/nginx/sites-enabled/pleroma.conf
    dfx sudo systemctl reload nginx.service
}

