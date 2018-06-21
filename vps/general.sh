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
    aptinstall oracle-java8-jdk nginx fcgiwrap postgresql samba \
        php5 php-pgsql php-gd php-fpm php-curl \
        rrdtool perl libwww-perl libmailtools-perl libmime-lite-perl \
        librrds-perl libdbi-perl libxml-simple-perl libhttp-server-simple-perl \
        libconfig-general-perl libio-socket-ssl-perl wiringpi etckeeper \
        letsencrypt python-certbot-nginx
}

network()
{
    dfx sudo sed -i 's/^127\.0\.1\.1.*/127.0.1.1\t'$domain' '$host'/' '/etc/hosts'
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
        dfx git clone "https://github.com/$erepo/$erepo.git" ~/$erepo
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

export -f ainstall
export -f network
export -f timezone
export -f motd
export -f ssl
export -f psql

