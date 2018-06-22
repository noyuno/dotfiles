#!/bin/bash -e

usage=$usage"
gitbucket.sh
    gitbucket: gitbucket service
    gitbucket_nginx: nginx routing for gitbucket
    gitbucket_psql: psql for gitbucket
    gitbucket_plugins: gitbucket plugins "

gitbucket()
{
    dfx sudo mkdir -p $gittarget/repo
    dfx useradd $gituser &&:
    dfx sudo chown -R $gituser.$gituser $gittarget
    cd $gittarget
    cat << EOF | sudo -u git tee $gittarget/update.sh
#!/bin/bash -e
curl -sL \$(curl -s https://api.github.com/repos/gitbucket/gitbucket/releases/latest | \\
    jq -r '.assets[] |select(.name=="gitbucket.war").browser_download_url') \\
    >/tmp/gitbucket.war
sudo systemctl stop gitbucket.service
sudo -u git cp /tmp/gitbucket.war $gittarget/gitbucket.war
sudo systemctl start gitbucket.service
EOF
    dfx sudo chmod +x $gittarget/update.sh
    if [ ! -e $gittarget/gitbucket.war ]; then
        dfx $gittarget/update.sh
    fi

    cat << EOF | sudo tee /etc/systemd/system/gitbucket.service
[Unit]
Description=Git hosting service

[Service]
User=git
ExecStart=$gittarget/run.sh
Restart = on-failure
RestartSec = 15s
StartLimitBurst = 5

[Install]
WantedBy=multi-user.target
EOF

    cat << EOF | sudo -u git tee $gittarget/run.sh
#!/bin/sh -e
(
/usr/bin/java -jar $gittarget/gitbucket.war --port=8080 \
    --gitbucket.home=$gittarget/repo
) >>/var/log/gitbucket.log 2>&1
EOF
    dfx sudo chmod +x $gittarget/run.sh

    cat << EOF | sudo tee /etc/logrotate.d/gitbucket
/var/log/gitbucket.log {
    weekly
    copytruncate
    rotate 12
    compress
    delaycompress
    notifempty
}
EOF

    if [ ! -e $gittarget/repo/gitbucket.conf ]; then
        cat << EOF | sudo tee $gittarget/repo/gitbucket.conf
oidc_authentication=false
gravatar=false
notification=false
useSMTP=false
skinName=skin-blue
is_create_repository_option_public=false
ldap_authentication=false
ssh=true
allow_account_registration=false
ssh.host=git.$domain
activity_log_limit=10000
allow_anonymous_access=true
information=Raspberry Pi Git server. <a href\="//$domain">Go to home</a>
ssh.port=4023
base_url=https\://git.$domain
EOF
    fi
    if [ ! -e $gittarget/repo/database.conf ]; then
        cat << EOF | sudo tee $gittarget/repo/database.conf
db {
  url = "jdbc:postgresql://localhost/gitbucket"
  user = "git"
  password = "database"
#  connectionTimeout = 30000
#  idleTimeout = 600000
#  maxLifetime = 1800000
#  minimumIdle = 10
#  maximumPoolSize = 10
}
EOF
    fi

    id $gituser 1>/dev/null 2>&1 &&:
    if [ $? -ne 0 ]; then
        dfx sudo useradd -d $gittarget -s /bin/zsh $gituser
    fi
    dfx sudo chown -R $gituser:$gituser $gittarget
    
    dfx sudo touch /var/log/gitbucket.log
    dfx sudo chown $gituser:$gituser /var/log/gitbucket.log

    dfx sudo systemctl daemon-reload
    dfx sudo systemctl enable gitbucket.service
    dfx sudo systemctl restart gitbucket.service
}

gitbucket_nginx()
{
    cat << EOF | sudo tee /etc/nginx/sites-available/gitbucket.conf

server {
    listen 80;
    server_name git.$domain;
    return 301 https://\$host\$request_uri;
}
server {
    listen 443 ssl;
    server_name git.$domain;
    
    ssl on;

    $certfile
    
    charset UTF-8;
    charset_types text/css application/json text/plain application/javascript;
    add_header 'Access-Control-Allow-Origin' '*' always;
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Headers' 'Content-Type,Accept';
    add_header 'Access-Control-Allow-Method' 'GET, POST, OPTIONS, PUT, DELETE';
    proxy_set_header Host \$http_host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_redirect off;
    proxy_max_temp_file_size 0;

    location /.well-known {
        alias /var/www/html/.well-known;
    }

    location / {
        proxy_pass http://localhost:8080;
        proxy_connect_timeout   150;
        proxy_send_timeout      100;
        proxy_read_timeout      100;
        proxy_buffers           4 32k;
        client_max_body_size    500m; # Big number is we can post big commits.
        client_body_buffer_size 128k;

    }

    location /robots.txt {
        alias /var/www/html/robots-disallow.txt;
    }

    location /assets/ {
        proxy_pass              http://localhost:8080/assets/;
        proxy_cache             cache;
        proxy_cache_key         \$host\$uri\$is_args\$args;
        proxy_cache_valid       200 301 302 1d;
        expires                 7d;
        gzip on;
        gzip_types text/html text/css application/javascript application/json;
    }

    location /console/ {
        deny all;
    }
}
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/gitbucket.conf \
        /etc/nginx/sites-enabled/gitbucket.conf
    dfx sudo systemctl reload nginx.service
}

gitbucket_plugins()
{
    plugins=$gittarget/repo/plugins
    dfx sudo -u git mkdir -p $plugins
    dfx sudo -u git wget -qO $plugins/gist-4.15.0.jar \
        https://github.com/gitbucket/gitbucket-gist-plugin/releases/download/4.15.0/gitbucket-gist-plugin-gitbucket_4.25.0-4.15.0.jar
    dfx sudo -u git wget -qO $plugins/network-1.5.jar \
        https://github.com/mrkm4ntr/gitbucket-network-plugin/releases/download/1.5/gitbucket-network-plugin_2.12-1.5.jar
    dfx sudo -u git wget -qO $plugins/mirror-1.0.2.jar \
        https://github.com/alexandremenif/gitbucket-mirror-plugin/releases/download/1.0.2/gitbucket-mirror-plugin-assembly-1.0.2.jar

    #dfx sudo wget -qO $plugins/pages-1.1.jar \
    #    https://github.com/gitbucket/gitbucket-pages-plugin/releases/download/v1.1/pages-plugin_2.12-1.1.jar

    dfx sudo chown -R $gituser:$gituser $plugins
    dfx sudo systemctl restart gitbucket.service
}

# hooks does not work
#gitsite()
#{
#    siteroot=/var/www/html
#    bare=$gittarget/repo/repositories/noyuno/site.git
#    dfx sudo mkdir -p /var/log/git
#    dfx sudo chown git:git /var/log/git
#    if [ -e $bare ]; then
#        if [ -e $siteroot ]; then
#            dfx pushd $siteroot
#                dfx sudo git pull origin master
#            dfx popd
#        else
#            dfx sudo git clone $bare $siteroot
#        fi
#
#        dfx sudo chown -R git:git $siteroot
#
#        cat << EOF | sudo -u git tee $bare/hooks/post-receive
##!/bin/bash -e
#
#(
#cd /var/www/html
#git pull origin master
#)>/var/log/git/site-post-receive 2>&1
#EOF
#        dfx sudo -u git chmod +x $bare/hooks/post-receive
#
#        com="$siteroot/bin/anime-refresh-local"
#        job="5 20 * * * $com"
#        cat <(fgrep -i -v "$com" <(sudo crontab -u git -l)) <(echo "$job") | \
#            sudo crontab -u git -
#    fi
#}

gitbucket_psql()
{
    cat << EOF | dfx sudo -u postgres psql
create database gitbucket WITH template template0 encoding 'utf8';
EOF
    dfx sudo -u postgres createuser --pwprompt --interactive git
}

export -f gitbucket
export -f gitbucket_nginx
export -f gitbucket_plugins
export -f gitbucket_psql

