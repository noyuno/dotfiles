#!/bin/bash -e

usage=$usage"
owncloud.sh
    owncloud: install owncloud
    owncloud_psql: clone repo
    owncloud_nginx: nginx setting"

owncloud () {
    wget -nv https://download.owncloud.org/download/repositories/production/Debian_9.0/Release.key -O /tmp/Release.key
    sudo apt-key add - < Release.key
    echo 'deb http://download.owncloud.org/download/repositories/production/Debian_9.0/ /' |sudo tee /etc/apt/sources.list.d/owncloud.list
    sudo apt update
    sudo apt install -y owncloud-files php7.0-fpm \
        libapache2-mod-php7.0 \
        openssl php-imagick php7.0-common php7.0-curl php7.0-gd \
        php7.0-imap php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring \
        php7.0-mcrypt php7.0-mysql php7.0-pgsql php-smbclient php-ssh2 \
        php7.0-sqlite3 php7.0-xml php7.0-zip
    sudo apt remove -y apache2 apache2-data apache2-utils
    sudo cp -f ~/dotfiles/raspberry-pi/php.conf /etc/php/7.0/fpm
    sudo cp -f ~/dotfiles/raspberry-pi/www.conf /etc/php/7.0/fpm/pool.d
    sudo chown -R $user:$user /var/lib/php7/sessions
    sudo chown -R $user:$user /var/www/owncloud
}

owncloud_psql () {
    sudo -u postgres psql -c "CREATE USER owncloud WITH PASSWORD 'owncloud';"
    sudo -u postgres psql -c "CREATE DATABASE owncloud TEMPLATE template0 ENCODING 'UNICODE';"
    sudo -u postgres psql -c "ALTER DATABASE owncloud OWNER TO owncloud;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE owncloud to owncloud;"
    cat << EOF | sudo tee -a /etc/postgresql/9.6/main/pg_hba.conf
local owncloud owncloud md5
host owncloud owncloud all password
EOF
    sudo systemctl reload postgresql
}

owncloud_nginx () {

    cat << EOF | sudo tee /etc/nginx/sites-available/70-owncloud.conf
upstream php-handler {
    server unix:/var/run/php/php7.0-fpm.sock;
}

server {
    listen 80;
    server_name dir.$domain;
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name  dir.$domain;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    charset UTF-8;

    root   /var/www/owncloud;

    client_max_body_size 10G;
    fastcgi_buffers 64 4K;

    rewrite ^/caldav(.*)$ /remote.php/caldav\$1 redirect;
    rewrite ^/carddav(.*)$ /remote.php/carddav\$1 redirect;
    rewrite ^/webdav(.*)$ /remote.php/webdav\$1 redirect;

    index index.php;
    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;

    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Headers' 'Content-Type,Accept';
    add_header 'Access-Control-Allow-Method' 'GET, POST, OPTIONS, PUT, DELETE';

    location = /robots.txt {
            allow all;
            log_not_found off;
            access_log off;
    }


    location ~ ^/(?:\.htaccess|data|config|db_structure\.xml|README) {
                deny all;
    }

    location / {
        rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
        rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

        rewrite ^/.well-known/carddav /remote.php/carddav/ redirect;
        rewrite ^/.well-known/caldav /remote.php/caldav/ redirect;

        rewrite ^(/core/doc/[^\/]+/)$ \$1/index.html;

        try_files \$uri \$uri/ index.php;
    }

    location ~ \.php(?:$|/) {
        root           /var/www/owncloud;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_pass php-handler;
        fastcgi_read_timeout 60;
        include        fastcgi_params;
    }
}

EOF

    sudo ln -sfnv /etc/nginx/sites-available/70-owncloud.conf /etc/nginx/sites-enabled/70-owncloud.conf 
    dfx sudo systemctl reload nginx

}
