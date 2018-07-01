#!/bin/bash -e

usage=$usage"
cert.sh
    cert: cert
    cert_update: update cert"

cert() {
    if [ "$certdomain" ]; then
        dfx sudo certbot certonly --webroot -w /var/www/cert $certdomain
    fi
}

