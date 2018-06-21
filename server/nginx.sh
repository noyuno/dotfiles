#!/bin/bash -e

usage=$usage"
nginx.sh
    nginx: nginx service "

nginx()
{

    sudo domainname $domain
    cat << EOF | sudo tee /etc/nginx/sites-available/00-root.conf
proxy_cache_path /var/lib/nginx/cache levels=1:2 keys_zone=cache:512m inactive=1d  max_size=5g;

server_tokens off;
server_names_hash_bucket_size 64;

#limit_req_zone \$binary_remote_addr zone=one:1m rate=300r/s;
#limit_req zone=one burst=300 nodelay;

server {
    listen 443 ssl;
    server_name $domain localhost;
    include /etc/nginx/mime.types;
    charset UTF-8;
    charset_types text/css application/json text/plain application/javascript;
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Headers' 'Content-Type,Accept';
    add_header 'Access-Control-Allow-Method' 'GET, POST, OPTIONS, PUT, DELETE';
    
    gzip on;
    gzip_types text/html text/css application/javascript application/json;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;

    root /var/www/html;
    
    location ~ .*\.(jpe?g|gif|png|css|js|ico|woff) {
        expires 7d;
    }

    location ~ /\.git {
        deny all;
    }

    location /log {
        deny all;
    }

    location ~ /secret {
        deny all;
    }

    location /bin {
        deny all;
    }

    location /jma/subscriber {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /var/www/html/jma/subscriber.php;
        include fastcgi_params;
    }

    location ~ \.php$ {
        root /var/www/html;
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ \.cgi$ {
        root /var/www/html;
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    
    location /cgi {
        root /var/www/html;
        try_files \$uri =404;
        fastcgi_pass unix:/var/run/fcgiwrap.socket;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}

server {
    listen 80;
    server_name $domain;
    return 301 https://$domain\$request_uri;
}


server {
    listen 80 default_server;
    server_name _;
    return 444;
}

server {
    listen 443 default_server;
    ssl on;
    server_name _;
    ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
    return 444;
}

server {
    listen 80;
    server_name $domain2 git.$domain2 status.$domain2 dir.$domain2 record.$domain2;
    return 301 https://$domain\$request_uri;
}
server {
    listen 443;
    server_name $domain2 git.$domain2 status.$domain2 dir.$domain2 record.$domain2;
    return 301 https://$domain\$request_uri;
}
EOF

    dfx sudo ln -sfnv /etc/nginx/sites-available/00-root.conf \
        /etc/nginx/sites-enabled/00-root.conf
    if [ -e /etc/nginx/sites-available/default ]; then
        dfx sudo mv /etc/nginx/sites-available/default ~/nginx-default-old
    fi
    dfx sudo ufw allow 80
    dfx sudo ufw allow 443
    dfx sudo systemctl reload nginx.service
    dfx sudo chown -R $user:$user /var/www/html
    dfx /var/www/html/bin/chown
}

export -f nginx

