#!/bin/bash -e

usage=$usage"
netdata.sh
    netdata: netdata service
    netdata_conf: netdata settings
    netdata_nginx: nginx routing for netdata "

netdata()
{
    bash <(curl -Ss https://my-netdata.io/kickstart.sh)
}

netdata_conf()
{
    pushd /etc/netdata
        sudo patch -bN < $HOME/dotfiles/patch/netdata/netdata.conf.patch
    popd
}

netdata_nginx()
{
    cat << EOF | sudo tee /etc/nginx/sites-available/netdata.conf
upstream backend {
    # the netdata server
    server 127.0.0.1:19999;
    keepalive 64;
}

server {
    # nginx listens to this
    listen 443 ssl;

    # the virtual host name of this
    server_name status.$domain;

    charset UTF-8;
    charset_types text/css application/json text/plain application/javascript;
    
    gzip on;
    gzip_types text/html text/css application/javascript application/json;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    location / {
        proxy_set_header X-Forwarded-Host \$host;
        proxy_set_header X-Forwarded-Server \$host;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_pass_request_headers on;
        proxy_set_header Connection "keep-alive";
        proxy_store off;
    }

    location /robots.txt {
        alias /var/www/html/robots-disallow.txt;
    }
}

server {
    listen 80;
    server_name status.$domain;
    return 301 https://status.$domain\$request_uri;
}
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/netdata.conf \
        /etc/nginx/sites-enabled/netdata.conf
    dfx sudo systemctl reload nginx.service

}

export -f netdata
export -f netdata_conf
export -f netdata_nginx

