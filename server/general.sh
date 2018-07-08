#!/bin/bash -e

usage=$usage"
general.sh
    ainstall: apt install
    network: set host to pi.\$domain
    timezone: set timezone to Tokyo
    motd: move motd
    ssl: letsencrypt
    psql: initialize postgresql
    ddns: ddns cron"

ainstall()
{
    dfx sudo debconf-set-selections '<<<' 'debconf shared/accepted-oracle-license-v1-1 select true'
    dfx sudo debconf-set-selections '<<<' 'debconf shared/accepted-oracle-license-v1-1 seen true'
    yes | sudo add-apt-repository ppa:webupd8team/java
    aptupdate
    aptupgrade
    aptinstall ${package[@]}
}

network()
{
    dfx sudo sed -i 's/^127\.0\.1\.1.*/127.0.1.1\tpi.'$domain' pi/' '/etc/hosts'
}

timezone()
{
    sudo timedatectl set-timezone Asia/Tokyo
}

motd()
{
    if [ -e /etc/motd ]; then
        dfx sudo mv /etc/motd /etc/motd.old
    fi
}

ssl()
{
    erepo=certbot
    if [ ! -d ~/$erepo ]; then
        dfx git clone "https://github.com/$erepo/$erepo.git" ~/$erepo --depth 1
    fi
    dfx pushd ~/$erepo
        dfx sudo ./letsencrypt-auto certonly --webroot -w /var/www/html \
            -d git.$domain -m $mail --agree-tos
    dfx popd

}

psql()
{
    if [ ! -d $pdata ]; then
        dfx sudo mkdir -p $pdata
        dfx sudo chown postgres:postgres $pdata
        dfx sudo -u postgres /usr/lib/postgresql/9.4/bin/initdb -D $pdata -E UTF8 --no-locale
    fi

    sudo systemctl restart postgresql.service
}

ddns()
{
    cat << EOF | sudo tee /etc/cron.d/ddnsauth
7,17,27,37,47,57 * * * * $user /home/$user/bin/ddnsauth
EOF
}

ufw () {
    dfx sudo ufw allow in from 192.168.11.1 to 192.168.11.0/24
}

export -f ainstall
export -f network
export -f timezone
export -f motd
export -f ssl
export -f psql
export -f ddns

