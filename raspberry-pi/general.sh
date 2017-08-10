#!/bin/bash -e

install()
{
    dfx sudo debconf-set-selections '<<<' 'debconf shared/accepted-oracle-license-v1-1 select true'
    dfx sudo debconf-set-selections '<<<' 'debconf shared/accepted-oracle-license-v1-1 seen true'
    aptinstall oracle-java8-jdk nginx fcgiwrap postgresql samba \
        php5 php5-pgsql php5-gd php5-fpm php5-curl \
        rrdtool perl libwww-perl libmailtools-perl libmime-lite-perl \
        librrds-perl libdbi-perl libxml-simple-perl libhttp-server-simple-perl \
        libconfig-general-perl libio-socket-ssl-perl
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
17 */6 * * * $user /home/$user/bin/ddnsauth
EOF
}

export -f install
export -f network
export -f timezone
export -f motd
export -f ssl
export -f psql
export -f ddns

