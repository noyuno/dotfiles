#!/bin/bash -e

pleroma () {
    cat << EOF | sudo tee /etc/systemd/system/pleroma.service
[Unit]
Description=Pleroma social network
After=network.target postgresql.service

[Service]
User=pleroma
WorkingDirectory=/var/pleroma/pleroma
Environment="HOME=/home/pleroma"
ExecStart=/usr/local/bin/mix phx.server
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

    cat << EOF | sudo tee /etc/nginx/sites-available/pleroma
    proxy_cache_path /tmp/pleroma-media-cache levels=1:2 keys_zone=pleroma_media_cache:10m max_size=10g
                    inactive=720m use_temp_path=off;

    server {
        listen         80;
        server_name    s.$domain;
        return         301 https://\$server_name\$request_uri;
    }

    server {
        listen 443;
        ssl on;
        ssl_session_timeout 5m;

        ssl_certificate           /etc/letsencrypt/live/$domain/cert.pem;
        ssl_certificate_key       /etc/letsencrypt/live/$domain/privkey.pem;

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers "HIGH:!aNULL:!MD5 or HIGH:!aNULL:!MD5:!3DES";
        ssl_prefer_server_ciphers on;

        server_name s.$domain;

        location / {
            add_header 'Access-Control-Allow-Origin' '*';
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host \$http_host;

            proxy_pass http://localhost:4040;
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

