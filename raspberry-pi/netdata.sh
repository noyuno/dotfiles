#!/bin/bash -e

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
    listen 80;

    # the virtual host name of this
    server_name status.$domain;

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
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/netdata.conf \
        /etc/nginx/sites-enabled/netdata.conf
    dfx sudo systemctl reload nginx.service

}

export -f netdata
export -f netdata_conf
export -f netdata_nginx
