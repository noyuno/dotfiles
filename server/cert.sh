#!/bin/bash -e

usage=$usage"
cert.sh
    cert: cert
    cert_update: update cert"

cert() {
    if [ "$certdomain" ]; then
        dfx sudo certbot certonly --webroot -w /var/www/cert --standalone -t $certdomain
    fi
    #sudo cp /etc/letsencrypt/live/$domain/fullchain.pem /var/www/html/ca/ca.crt
    #openssl x509 -outform der -in /var/www/html/ca/ca.crt >/var/www/html/ca/ca.der
}

cert_update () {
    cat << EOF | sudo tee /etc/cron.d/cert
16 3 * * * root /usr/bin/certbot renew --webroot-path /var/www/cert/ --nointeractive --renew-hook /home/noyuno/dotfiles/server/cert-deploy
EOF
}

