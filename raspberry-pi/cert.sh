#!/bin/bash -e

usage=$usage"
cert.sh
    cert: cert
    cert_update: update cert"

cert() {
    sudo certbot certonly --standalone -t \
        -d $domain \
        -d dir.$domain  \
        -d git.$domain \
        -d file.$domain \
        -d files.$domain \
        -d storage.$domain \
        -d drive.$domain \
        -d s.$domain \
        -d p.$domain \
        -d vps.$domain \
        -d record.$domain \
        -d status.$domain \
        -d kanban.$domain \
        -d bot.$domain  \
        -d trash.$domain \
        -d www.$domain \
        -d blog.$domain \
        -d mail.$domain \
        -d dns.$domain \
    #sudo cp /etc/letsencrypt/live/$domain/fullchain.pem /var/www/html/ca/ca.crt
    #openssl x509 -outform der -in /var/www/html/ca/ca.crt >/var/www/html/ca/ca.der
}

cert_update () {
    cat << EOF | sudo tee /etc/cron.d/cert
16 3 * * * root /usr/bin/certbot renew --nointeractive --renew-hook /bin/systemctl reload nginx
EOF
}

