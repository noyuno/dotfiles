#!/bin/bash -e

nginx()
{

    sudo domainname $domain
    cat << EOF | sudo tee /etc/nginx/sites-available/00-root.conf
proxy_cache_path /var/lib/nginx/cache levels=1:2 keys_zone=cache:512m inactive=1d  max_size=60g;

server_tokens off;
server_names_hash_bucket_size 64;

server {
    listen 80;
    server_name $domain localhost;
    include /etc/nginx/mime.types;
    charset UTF-8;
    charset_types text/css application/json text/plain application/javascript;
    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Headers' 'Content-Type,Accept';
    add_header 'Access-Control-Allow-Method' 'GET, POST, OPTIONS, PUT, DELETE';

    location / {
        root /var/www/html;
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
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/00-root.conf \
        /etc/nginx/sites-enabled/00-root.conf
    dfx sudo systemctl reload nginx.service
    dfx sudo chown -R $user:$user /var/www/html
    dfx /var/www/html/bin/chown
}

anime()
{
    cat << EOF | sudo tee /etc/cron.d/anime
19 */12 * * * $user /var/www/html/bin/get-anime
EOF
}

export -f nginx
export -f anime

