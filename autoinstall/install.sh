#!/bin/bash -e
# crypto-home-unlock-usb-rclocal.sh

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

cryptoname=crypto-vg0-lv1

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
    dfx cryptsetup open --type luks /dev/vg0/lv1 $cryptoname
    dfx mkfs.ext4 /dev/mapper/$cryptoname
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
    dfx mkdir -p /target
    targetmount /dev/vg0/lv0 /target
    targetmount /dev /target/dev --rbind
    targetmount none /target/proc -t proc
    targetmount /sys /target/sys --rbind
    targetmount /run /target/run --rbind
    dfx mkdir -p /target/tmp
    dfx wget -N -P /target/tmp 'https://raw.githubusercontent.com/noyuno/dotfiles/master/autoinstall/luks.sh'
    usbuuid=$(sudo blkid|grep "^$1:"|sed -e 's/.* UUID="//' -e 's/" .*//')
    dfx chroot /target bash /tmp/luks.sh "$1" "$usbuuid"
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

help()
{
    curl -sL 'https://raw.githubusercontent.com/noyuno/dotfiles/master/autoinstall/readme-install.sh'
    exit 1
}
if [ $# -le 1 ]; then
    help
fi

if [ "$1" = "luks" ]; then
    luks "$2"
elif [ "$1" = "clean" ]; then
    clean
else
    partitioning "$1" "$2"
fi

