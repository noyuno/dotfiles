#!/bin/bash -e

usage=$usage"
minecraft.sh
    minecraft: sandbox video game"

mcdir=$HOME/minecraft

minecraft ()
{
    mkdir $mcdir
    wget -O $mcdir/server.jar \
        "https://launcher.mojang.com/mc/game/1.12.2/server/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar"
    cat << EOF | tee $mcdir/eula.txt
eula=true
EOF
    cat << EOF | tee $mcdir/run.sh
#!/bin/sh
java -Xmx1024M -Xms1024M -jar server.jar nogui
EOF
    cat << EOF | sudo tee /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft sandbox video game server

[Service]
ExecStart=$mcdir/run.sh
Type=simple
Restart=on-failure
RestartSec=15s
User=noyuno
WorkingDirectory=$mcdir

[Install]
WantedBy=multi-user.target
EOF
    
    dfx chmod +x $mcdir/run.sh

    dfx sudo systemctl enable minecraft
    dfx sudo systemctl start minecraft

}

spigot() {
    cat << EOF | tee $mcdir/run.sh
#!/bin/bash -e

pushd server >/dev/null
    java -Xmx1024M -Xms1024M -jar spigot-1.12.2.jar nogui
popd >/dev/null
EOF
}

minecraft_backup() {
    cat << EOF | sudo tee /etc/cron.d/minecraft-backup
36 3 * * * root $mcdir/backup.sh
EOF
    cat << EOF | tee $mcdir/backup.sh
#!/bin/bash -ex

set -ex

sudo -u noyuno rm -rf $mcdir/server.bak
systemctl stop minecraft
sync
sudo -u noyuno cp -r $mcdir/server $mcdir/server.bak
systemctl start minecraft
d=\$($HOME/dotfiles/bin/now)
sudo -u noyuno tar cf server.tar.gz server.bak
sudo -u noyuno tar cf optout.tar.gz server/world server/world_nether server/world_the_end
#opt="-p 4022 -i ~/.ssh/mcbackup"
sudo -u noyuno scp -P 4022 -i ~/.ssh/mcbackup server.tar.gz \
    mcbackup@pi.noyuno.space:/mnt/karen/share/backup/k/minecraft/\$d.tar.gz
sudo -u noyuno mv optout.tar.gz /var/www/html/minecraft/data/optout.tar.gz
#sudo -u noyuno rsync -a -A -z -C --delay-updates --info=progress2 -h --info=name0 \
#    -e "ssh \$opt" \
#    $mcdir/server.bak/ mcbackup@pi.noyuno.space:/mnt/karen/share/backup/k/minecraft/\$d/

EOF

    chmod +x $mcdir/backup.sh
}

dynmap_nginx() {
    cat << EOF | sudo tee /etc/nginx/sites-available/dynmap.conf

server {
    listen 80;
    server_name mc.$rootdomain;
    $upgrade
}

server {
    listen 443 ssl;
    server_name mc.$rootdomain;
    
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

    location ^~ /map/ {
        rewrite /map/(.*) /\$1 break;
        proxy_pass http://localhost:8123;
        proxy_connect_timeout   150;
        proxy_send_timeout      100;
        proxy_read_timeout      100;
        proxy_buffers           4 32k;
        client_max_body_size    500m; # Big number is we can post big commits.
        client_body_buffer_size 128k;
    }

    location / {
        root /var/www/html/minecraft;
    }
}
EOF
    dfx sudo ln -sfnv /etc/nginx/sites-available/dynmap.conf \
        /etc/nginx/sites-enabled/dynmap.conf
    dfx sudo systemctl reload nginx.service

}

