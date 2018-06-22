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
        php7.0-sqlite3 php7.0-xml php7.0-zip \
        redis-server php-redis
    sudo apt remove -y apache2 apache2-data apache2-utils
    sudo cp -f ~/dotfiles/raspberry-pi/php.conf /etc/php/7.0/fpm
    sudo cp -f ~/dotfiles/raspberry-pi/www.conf /etc/php/7.0/fpm/pool.d
    sudo cp -f ~/dotfiles/raspberry-pi/redis.conf /etc/redis/redis.conf
    sudo chown -R $user:$user /var/lib/php7/sessions
    sudo chown -R $user:$user /var/www/owncloud

    cat << EOF | sudo tee /etc/cron.d/owncloud
*/15 * * * * www-data php -f /var/www/owncloud/cron.php
EOF
}

owncloud_config () {
    cat << EOF | tee /var/www/owncloud/config/config.php
<?php↲
$CONFIG = array (
  'updatechecker' => false,
  'instanceid' => 'ocaof9bstigc',
  'trusted_domains' =>-
  array (↲
    0 => 'dir.noyuno.mydns.jp',
    1 => 'dir.noyuno.space',
  ),↲
  'datadirectory' => '/mnt/karen/owncloud',
  'overwrite.cli.url' => 'http://dir.noyuno.mydns.jp',
  'dbtype' => 'pgsql',
  'version' => '10.0.8.5',
  'dbname' => 'owncloud',
  'dbhost' => 'localhost:5432',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'owncloud',
  'dbpassword' => 'owncloud',
  'logtimezone' => 'UTC',
  'installed' => true,
  'theme' => '',
  'loglevel' => 0,
  'maintenance' => false,
  'filelocking.enabled' => true,
  'memcache.locking' => '\OC\Memcache\Redis',
  'memcache.local' => '\OC\Memcache\Redis',
    'redis' => array(
    'host' => 'localhost',
    'port' => 6379,
  ),
  'files_external_allow_create_new_local' => 'true'
);
EOF

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
    $gradeup
}

server {
    listen 443 ssl http2;
    server_name dir.$domain;

    $certfile

    # Add headers to serve security related headers
    # Before enabling Strict-Transport-Security headers please read into this topic first.
    #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;

    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Methods' 'POST, GET, OPTIONS' always;
    add_header 'Access-Control-Allow-Headers' 'Authorization, Content-Type' always;

    # Path to the root of your installation
    root /var/www/owncloud/;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.
    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

    location = /.well-known/carddav {
        return 301 \$scheme://\$host/remote.php/dav;
    }
    location = /.well-known/caldav {
        return 301 \$scheme://\$host/remote.php/dav;
    }

    # set max upload size
    client_max_body_size 10G;
    fastcgi_buffers 8 4K;                     # Please see note 1
    fastcgi_ignore_headers X-Accel-Buffering; # Please see note 2

    # Disable gzip to avoid the removal of the ETag header
    # Enabling gzip would also make your server vulnerable to BREACH
    # if no additional measures are done. See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=773332
    gzip off;

    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;

    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;

    location / {
        rewrite ^ /index.php\$uri;
    }

    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
        return 404;
    }
    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
        return 404;
    }

    location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|core/templates/40[34])\.php(?:$|/) {
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME \$fastcgi_script_name; # necessary for owncloud to detect the contextroot https://github.com/owncloud/core/blob/v10.0.0/lib/private/AppFramework/Http/Request.php#L603
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_param HTTPS on;
        fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
        fastcgi_param front_controller_active true;
        fastcgi_read_timeout 180; # increase default timeout e.g. for long running carddav/ caldav syncs with 1000+ entries
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off; #Available since NGINX 1.7.11

    }

    location ~ ^/(?:updater|ocs-provider)(?:$|/) {
        try_files \$uri \$uri/ =404;
        index index.php;
    }

    # Adding the cache control header for js and css files
    # Make sure it is BELOW the PHP block
    location ~ \.(?:css|js)$ {
        try_files \$uri /index.php\$uri\$is_args\$args;
        add_header Cache-Control "max-age=15778463";
        # Add headers to serve security related headers (It is intended to have those duplicated to the ones above)
        # Before enabling Strict-Transport-Security headers please read into this topic first.
        #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options "SAMEORIGIN";
        add_header X-XSS-Protection "1; mode=block";
        add_header X-Robots-Tag none;
        add_header X-Download-Options noopen;
        add_header X-Permitted-Cross-Domain-Policies none;
        # Optional: Don't log access to assets
        access_log off;
    }

    location ~ \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg|map)$ {
        add_header Cache-Control "public, max-age=7200";
        try_files \$uri /index.php\$uri\$is_args\$args;
        # Optional: Don't log access to other assets
        access_log off;
    }
}
EOF

    sudo ln -sfnv /etc/nginx/sites-available/70-owncloud.conf /etc/nginx/sites-enabled/70-owncloud.conf 
    dfx sudo systemctl reload nginx

}
