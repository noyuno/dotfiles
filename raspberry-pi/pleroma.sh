#!/bin/bash -e

pleroma () {
#echo "deb https://packages.erlang-solutions.com/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/erlang-solutions.list
#wget https://packages.erlang-solutions.com/debian/erlang_solutions.asc
#sudo apt-key add erlang_solutions.asc
#sudo apt update
#sudo apt install elixir erlang erlang-xmerl
#
#
#mix deps.get
#mix generate_config
#sudo su postgres -c 'psql -f config/setup_db.psql'

    cat << EOF | sudo tee /etc/systemd/system/pleroma.service
[Unit]
Description=Pleroma social network
After=network.target postgresql.service

[Service]
User=pleroma
WorkingDirectory=/var/pleroma/pleroma
Environment="MIX_ENV=prod"
ExecStart=/usr/local/bin/mix phx.server
StandardOutput=null
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
    return         301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    ssl on;
    ssl_session_timeout 5m;

    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
    ssl_prefer_server_ciphers on;

    server_name s.$domain;

    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript application/activity+json application/atom+xml;

    client_max_body_size 16m;

    #location /.well-known {
    #    alias /var/www/html/.well-known;
    #}

    location / {
        # if you do not want remote frontends to be able to access your Pleroma backend
        # server, remove these lines.
        add_header 'Access-Control-Allow-Origin' '*' always;
        add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
        add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;
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

