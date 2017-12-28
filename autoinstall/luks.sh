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

cryptoname=crypto-vg0-lv1

luks() {
    usbd="$1"
    if [ $# -eq 2 ]; then
        usbuuid="$2"
    else
        usbuuid=$(sudo blkid|grep "^$usbd:"|sed -e 's/.* UUID="//' -e 's/" .*//')
    fi
    dfout2 "usbuuid=$usbuuid"

    mount | grep "^$usbd " >/dev/null &&:
    if [ $? -ne 0 ]; then
        dfx umount "$usbd"
    fi
    if [ ! -e "/dev/mapper/$cryptoname" ]; then
        dfx cryptsetup open --type luks /dev/vg0/lv1 $cryptoname
    fi
    dfx mkdir -p /mnt/luksusb
    targetmount "$usbd" /mnt/luksusb

    keyfile=/cryptokey/$(cat /etc/hostname)
    dfx mkdir -p /mnt/luksusb/cryptokey
    dfx cat /dev/urandom '|' \
        tr -dc 'a-zA-Z0-9' '|' \
        fold -w 64 '|' head -n 32 '|' sort '|' uniq '>' /mnt/luksusb$keyfile
    dfx cryptsetup luksAddKey /dev/vg0/lv1 /mnt/luksusb$keyfile

    dfx sed -i -e "s|^/dev/mapper/$cryptoname |#&|" /etc/fstab
}

install() {
    rclocal=/etc/rc.local
    rclocal2=/usr/local/bin/unlockluks
    dfout3 "$rclocal"
    if [ -e "$rclocal" ]; then
        if ! grep "$rclocal2" < "$rclocal" ; then
            cat << EOF | sudo tee -a "$rclocal"
bash $rclocal2
EOF
        fi
    else
        cat << EOF | sudo tee "$rclocal"
#!/bin/bash -e

bash $rclocal2
exit \$_
EOF
    fi
    dfx chmod +x "$rclocal"

    dfx wget -N -O "$rclocal2" \
        'https://raw.githubusercontent.com/noyuno/dotfiles/master/autoinstall/unlockluks'
    dfx chmod +x "$rclocal2"

    dfx echo "$usbuuid" '>>' /etc/luksusb

    dfx mkdir -p /etc/lightdm/lightdm.conf.d
    dfout3 /etc/lightdm/lightdm.conf.d/luks.conf
    cat << EOF > /etc/lightdm/lightdm.conf.d/luks.conf
[SeatDefaults]
greeter-setup-script=/usr/local/bin/waitluks
EOF

    dfout3 /usr/local/bin/waitluks
    cat << "EOF" > /usr/local/bin/waitluks
#!/bin/bash -e
 
(
while [ ! -e /tmp/luks.end ]; do
    sleep 1
done
echo 100
) | zenity --progress --text="unlocking /home" --pulsate --auto-close --no-cancel
text="$(cat /tmp/luks.end)"
echo -n "" > /tmp/luks.end
if [ "$text" ]; then
    zenity --error --timeout 3 --text="$text" &&:
fi
EOF
    dfx chmod +x /usr/local/bin/waitluks

    cat << EOF > /usr/local/bin/openluks
#!/bin/bash -e

sudo cryptsetup open --type luks /dev/vg0/lv1 $cryptoname
sudo mount $cryptoname /home
EOF
    dfx chmod +x /usr/local/bin/openluks

    cat << EOF > /etc/udev/rules.d/luks.rules
ACTION=="add", SUBSYSTEM=="usb", RUN+="/usr/local/bin/unlockluks"
EOF

    dfx update-initramfs -u
}

help()
{
    curl -sL 'https://raw.githubusercontent.com/noyuno/dotfiles/master/autoinstall/readme-luks.md'
    exit 1
}

if [ $# -ge 1 ]; then
    if [ "$1" = "-h" -o "$1" = "--help" ]; then
        help
    else
        luks $*
        install $*
    fi
else
    help
fi

