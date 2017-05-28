#!/bin/bash -e

dfout1()
{
    printf "\e[1;37m\e[44m%s\e[0m\n" "$*"
}

dfout2()
{
    printf "\e[34m%s\e[0m\n" "$*"
}

dfout3()
{
    printf "\e[32m%s\e[0m\n" "$*"
}

dfx()
{
    if [ "$HOME" = "" ]; then
        dfout2 'Unable to find $HOME'
        exit 1
    fi 
    a=""
    c=""
    while [ $# -gt 0 ]; do
        b="$1"
        case "$b" in
        '|'|'||'|'&'|'&&'|'>'|'>>'|'>>>'|'<'|'<<'|'<<<'|'&&:')
            a="$a$b "
            c="$c$b "
            ;;
        *)
            b=$(printf "%s" "$b" | sed -e "s|~|$HOME|g" \
                -e "s/^'//g" -e "s/'$//g" -e "s/'/'\"'\"'/g")
            a="$a'$b' "
            c="$c$b "
            ;;
        esac
        shift
    done 
    dfout3 "$c"
    if [ ! "$DRYRUN" ]; then
        if [ "$QUIET" ]; then
            eval command $a 1>/dev/null
        else
            eval command $a
        fi
    fi
}

partitioning()
{
    target=$1
    rootsize=$2
    
    dfx parted -s "$target" -a optimal -- \
        mklabel gpt \
        mkpart primary 1 100M \
        set 1 boot on \
        mkpart primary 100M -1 \
        set 2 lvm on \
        mkpart primary 34s 1041s \
        set 3 bios_grub on
    dfx sync
    dfx mkfs.vfat -F 32 "$target"1
    dfx pvcreate -ff "$target"2
    dfx vgcreate vg0 "$target"2
    dfx lvcreate -L "$rootsize" -n lv0 vg0
    dfx lvcreate -l 100%FREE -n lv1 vg0
    dfx mkfs.ext4 /dev/vg0/lv0
    dfx cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/vg0/lv1
    dfx cryptsetup open --type luks /dev/vg0/lv1 crypt-vg0-lv1
    dfx mkfs.ext4 /dev/mapper/crypt-vg0-lv1
    dfx sync
}

targetmount()
{
    m=$(mount | grep "^$1\ ")
    if [ ! "$m" ]; then
        dfx mount $3 "$1" "$2"
    elif [[ ! "$m" =~ ^$1\ on\ $2\  ]]; then
        echo "$1 already mounted at other point\n$m" >&2
        exit 1
    fi
}

# http://stackoverflow.com/questions/19713918/how-to-load-luks-passphrase-from-usb-falling-back-to-keyboard
# http://www.cheshirekow.com/wordpress/?p=810

luks()
{
    usbd="$1"
    usbuuid=$(sudo blkid|grep "^$usbd:"|sed -e 's/.* UUID="//' -e 's/" .*//')
    startupscript=/lib/cryptsetup/scripts/startup
    keyfile=/lukskey
    crypttab=/etc/crypttab

    mount | grep "^$1 " >/dev/null &&:
    if [ $? -ne 0 ]; then
        dfx umount "$1"
    fi
    if [ ! -e "/dev/mapper/crypt-vg0-lv1" ]; then
        dfx cryptsetup open --type luks /dev/vg0/lv1 crypt-vg0-lv1
    fi
    dfx mkdir -p /target
    dfx mkdir -p /mnt/luksusb
    targetmount /dev/vg0/lv0 /target
    targetmount "$usbd" /mnt/luksusb

    dfx cat /dev/urandom '|' \
        tr -dc 'a-zA-Z0-9' '|' \
        fold -w 64 '|' head -n 32 '|' sort '|' uniq '>' /mnt/luksusb$keyfile
    dfx cryptsetup luksAddKey /dev/vg0/lv1 /mnt/luksusb$keyfile

    dfout2 "usbuuid=$usbuuid"
    dfout3 "generating /target$crypttab"
    cat << EOF > /target$crypttab
crypt-vg0-lv1 /dev/vg0/lv1 /dev/disk/by-uuid/$usbuuid:$keyfile:3 luks,keyscript=$startupscript,discard,timeout=10
EOF

    dfout3 "/target$startupscript"
    cat << "EOF" > /target$startupscript
#!/bin/sh
/lib/cryptsetup/scripts/passdev $1
if [ $? = 1 ]; then
    /lib/cryptsetup/askpass "CANNOT OPEN LUKS LV. PLEASE TYPE PASSPHRASE: "
fi
EOF
    dfx chmod +x /target$startupscript

    dfout3 "patching /usr/share/initramfs-tools/scripts/local-top/cryptroot"
    cat << "EOF" | patch -u /usr/share/initramfs-tools/scripts/local-top/cryptroot
--- /usr/share/initramfs-tools/scripts/local-top/cryptroot      2015-08-21 17:04:52.000000000 +0900
+++ cryptroot   2017-04-09 09:26:24.658683073 +0900
@@ -7,13 +7,7 @@
 #
 prereqs()
 {
-       # Make sure that cryptroot is run last in local-top
-       for req in $(dirname $0)/*; do
-               script=${req##*/}
-               if [ $script != cryptroot ]; then
-                       echo $script
-               fi
-       done
+    echo "$PREREQ"
 }

 case $1 in
EOF
    
    dfout3 "/target/etc/initramfs-tools/modules"
    cat << EOF >> /target/etc/initramfs-tools/modules
uhci_hcd
ehci_hcd
usb_storage
vfat
nls_cp437
nls_ascii
EOF
    dfx chroot /target update-initramfs -u
}

clean()
{
    dfx lvremove /dev/vg0/lv0 &&:
    dfx lvremove /dev/vg0/lv1 &&:
    dfx vgremove vg0 &&:
    dfx pvremove /dev/sda2 &&:
    dfx parted -s /dev/sda -- \
        mklabel gpt
    dfx sync
}

if [ $# -le 1 ]; then
    echo 'target device and root size required (e.g. /dev/sda 20G, luks /dev/sdb1)'
    exit 1
fi

if [ "$1" = "luks" ]; then
    luks "$2"
elif [ "$1" = "clean" ]; then
    clean
else
    partitioning "$1" "$2"
fi

