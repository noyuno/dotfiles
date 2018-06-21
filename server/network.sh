#!/bin/bash -e

usage=$usage"
network.sh
    network: configure network"

network()
{

cat << EOF | sudo tee /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet static
    address 192.168.11.40
    netmask 255.255.255.0
    network 192.168.11.0
    gateway 192.168.11.1

# gitbucket
auto eth0:0
allow-hotplug eth0:0
iface eth0:0 inet static
    address 192.168.11.41
    netmask 255.255.255.0
    network 192.168.11.0
    gateway 192.168.11.1

auto eth0:1
allow-hotplug eth0:1
iface eth0:1 inet static
    address 192.168.11.42
    netmask 255.255.255.0
    network 192.168.11.0
    gateway 192.168.11.1

auto eth0:2
allow-hotplug eth0:2
iface eth0:2 inet static
    address 192.168.11.43
    netmask 255.255.255.0
    network 192.168.11.0
    gateway 192.168.11.1

auto eth0:3
allow-hotplug eth0:3
iface eth0:3 inet static
    address 192.168.11.44
    netmask 255.255.255.0
    network 192.168.11.0
    gateway 192.168.11.1

allow-hotplug wlan0
iface wlan0 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

allow-hotplug wlan1
iface wlan1 inet manual
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

EOF

    echo "Type sudo systemctl restart networking"
}
