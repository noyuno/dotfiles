#!/bin/bash -e

usage=$usage"
localnet.sh
    samba: samba file sharering
    zeroconf: avahi zeroconf service
    pychromecast: Chromecast for Python library "
samba()
{
    cat << "EOF" | sudo tee /etc/samba/smb.conf
[global]
    dos charset = cp932
    unix charset = UTF8
    display charset = UTF8
    workgroup = WORKGROUP
    dns proxy = no
    log file = /var/log/samba/log.%m
    max log size = 1000
    syslog = 0
    panic action = /usr/share/samba/panic-action %d
    server role = standalone server
    passdb backend = tdbsam
    obey pam restrictions = yes
    unix password sync = yes
    passwd program = /usr/bin/passwd %u
    passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
    pam password change = yes
    map to guest = bad user
    usershare allow guests = yes

[homes]
    comment = Home Directories
    browseable = no
    read only = yes
    create mask = 0700
    directory mask = 0700
    valid users = %S

[printers]
    comment = All Printers
    browseable = no
    path = /var/spool/samba
    printable = yes
    guest ok = no
    read only = yes
    create mask = 0700

[pi]
    path = /var/samba/share
    read only = no
    guest ok = yes
    force user = nobody
    create mask = 777
    directory mask = 777
EOF

    dfx sudo ufw allow 137
    dfx sudo ufw allow 138
    dfx sudo ufw allow 139
    dfx sudo ufw allow 445

    dfx sudo mkdir -p /var/samba/share

    dfx sudo service smbd restart
    dfx sudo service nmbd restart
}

zeroconf()
{
    cat << EOF | sudo tee /etc/avahi/services/pi.service
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">
<service-group>
    <name replace-wildcards="yes">%h</name>
    <service>
        <type>_smb._tcp</type>
        <port>139</port>
    </service>
    <service>
        <type>_http._tcp</type>
        <port>80</port>
    </service>
</service-group>
EOF
    dfx sudo systemctl restart avahi-daemon.service
}

pychromecast()
{
    sudo pip3 install pychromecast

}

export -f samba
export -f zeroconf
export -f pychromecast

