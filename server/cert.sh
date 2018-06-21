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
        -d a.$domain \
        -d b.$domain \
        -d c.$domain \
        -d d.$domain \
        -d e.$domain \
        -d f.$domain \
        -d g.$domain \
        -d h.$domain \
        -d i.$domain \
        -d j.$domain \
        -d k.$domain \
        -d l.$domain \
        -d m.$domain \
        -d n.$domain \
        -d o.$domain \
        -d p.$domain \
        -d q.$domain \
        -d r.$domain \
        -d s.$domain \
        -d t.$domain \
        -d u.$domain \
        -d v.$domain \
        -d w.$domain \
        -d x.$domain \
        -d y.$domain \
        -d z.$domain \
        -d record.$domain \
        -d status.$domain \
        -d kanban.$domain \
        -d bot.$domain  \
        -d trash.$domain \
        -d www.$domain \
        -d blog.$domain \
        -d mail.$domain \
        -d dns.$domain
    #sudo cp /etc/letsencrypt/live/$domain/fullchain.pem /var/www/html/ca/ca.crt
    #openssl x509 -outform der -in /var/www/html/ca/ca.crt >/var/www/html/ca/ca.der
}

cert_update () {
    cat << EOF | sudo tee /etc/cron.d/cert
16 3 * * * root /usr/bin/certbot renew --nointeractive --renew-hook /bin/systemctl reload nginx
EOF
}

