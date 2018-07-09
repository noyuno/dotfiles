#!/bin/bash -e

usage=$usage"
minecraft.sh
    minecraft: sandbox video game"

minecraft ()
{
    mcdir=$HOME/minecraft
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

