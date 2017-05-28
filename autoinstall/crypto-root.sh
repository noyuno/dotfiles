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
        mkpart primary 100M 500M \
        mkpart primary 500M -1 \
        set 3 lvm on \
        mkpart primary 34s 1041s \
        set 4 bios_grub on
    dfx sync
    dfx mkfs.vfat -F 32 "$target"1
    dfx mkfs.ext4 "$target"2

    dfx cryptsetup -y luksFormat -c aes-xts-plain64 -s 512 /dev/sda3
    dfx cryptsetup open --type luks /dev/sda3 cryptroot
    dfx mkfs.ext4 /dev/mapper/cryptroot
    cat /dev/urandom | \
        tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 32 | sort | uniq > lukskey
    dfx cryptsetup luksAddKey /dev/sda3 lukskey
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

luks()
{
    if [ ! -e "/dev/mapper/cryptroot" ]; then
        dfx cryptsetup open --type luks /dev/sda3 cryptroot
    fi
    dfx mkdir -p /target
    targetmount /dev/mapper/cryptroot /target
    targetmount /dev/sda2 /target/boot
    targetmount /dev /target/dev --rbind
    targetmount /sys /target/sys --rbind
    targetmount /proc /target/proc "-t proc"
    uuid=$(blkid | grep '/dev/sda3' | sed -e 's/.* UUID="//' -e 's/" .*//')
    cat << EOF > /target/etc/crypttab
cryptroot UUID=$uuid /dev/sda2:/lukskey luks,keyscript=/lib/cryptsetup/scripts/passdev
EOF
    cat << EOF >> /target/etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=UUID=$uuid:cryptroot cryptkey=/dev/sda2:ext4:/lukskey root=/dev/mapper/cryptroot"
EOF
    dfx cp lukskey /target/boot/lukskey
    dfx chroot /target grub-mkconfig -o /boot/grub/grub.cfg
    dfx chroot /target update-initramfs -u -k all
}

if [ $# -eq 0 ]; then
    echo 'target device required (e.g. /dev/sda, luks)'
    exit 1
fi

if [ "$1" = "luks" ]; then
    luks
else
    rootsize=100G
    if [ $# -eq 2 ]; then
        rootsize="$2"
    fi
    partitioning "$1" "$rootsize"
fi

