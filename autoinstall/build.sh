#!/bin/bash -e

. "$HOME/dotfiles/bin/dffunc"

# http://sig9.hatenablog.com/entry/2016/09/10/120000
base=$HOME/dotfiles/autoinstall

build()
{
    mount | grep "$src" &&:
    if [ $? -ne 0 ]; then
        dfx sudo mount -t iso9660 -r "$src" "$tmps"
    fi
    dfx cd "$tmps"
    dfx find . ! -type l '|' cpio -pdum "$tmpd"
    dfx cd
    #dfx sudo umount "$src"
    
    dfx chmod +w "$tmpd/isolinux"
    dfx cp -f "$base/isolinux.cfg" "$tmpd/isolinux/isolinux.cfg"
    sed -i -e "s/!title!/$vname/g" -e "s|!date!|$(date +%Y/%m/%d)|g" \
        "$tmpd/isolinux/isolinux.cfg"
    
    dfx chmod +w "$tmpd/preseed"
    dfx cp -f "$base/ubuntu-mate-16.04-preseed.cfg" \
        "$tmpd/preseed/preseed.cfg"
    
    dfx chmod +w "$tmpd/isolinux" "$tmpd/isolinux/isolinux.bin"
    dfx genisoimage -N -J -R -D -V "PRESEED" \
        -o "$dest" \
        -b isolinux/isolinux.bin \
        -c isolinux/boot.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        "$tmpd"
}

launch() {
    createvm=
    vboxmanage showvminfo "$vname" >/dev/null &&:
    if [ $? -ne 0 ]; then
        createvm=1
        dfx vboxmanage createvm --name "$vname" --ostype "Ubuntu_64" \
            --basefolder "$tmpv" --register
        dfx vboxmanage modifyvm "$vname" --memory 2048 --vram 128 --cpus 4
    else
        dfx vboxmanage controlvm "$vname" poweroff &&:
        dfx vboxmanage storageattach "$vname" --storagectl "SATA" --device 0 \
            --port 1 --type hdd --medium none &&:
    fi
    dfx vboxmanage closemedium disk "$tmpv/storage.vdi" --delete &&:
    dfx vboxmanage createmedium disk --filename "$tmpv/storage.vdi" --size 30000
    if [ "$createvm" ]; then
        dfx vboxmanage storagectl "$vname" --name "SATA" --add sata \
            --controller IntelAHCI --portcount 2 --bootable on
    fi
    dfx vboxmanage storageattach "$vname" --storagectl "SATA" --device 0 \
        --port 0 --type dvddrive --medium "$dest"
    dfx vboxmanage storageattach "$vname" --storagectl "SATA" --device 0 \
        --port 1 --type hdd --medium "$tmpv/storage.vdi"
    dfx vboxmanage startvm "$vname" --type gui
}

help()
{
    {
        name=${0##*/}
        cat << EOF
Usage: $name [-v|-s|-o dest] src
EOF
    } 1>&2
    exit 1
}

args=$(getopt -o hvso -l help -- $*)
set -- $args

vbox=
skipbuild=
destgiven=

while [ $# -gt 0 ]; do
    case $1 in
    --) shift; break ;;
    -v) vbox=1 ;;
    -s) skipbuild=1 ;;
    -o) destgiven=1; dest=$(echo "$2" | sed "s/'//g"); shift ;;
    -h|--help) help ;;
    esac
    shift
done

src=$(echo $* | sed "s/'//g")
if [ ! "$destgiven" ]; then
    dest="${src%.*}-preseed.iso"
fi
filename=${src##*/}
vname="${filename%.*}-preseed"
tmps="/tmp/preseed/${filename%.*}/src"
tmpd="/tmp/preseed/${filename%.*}/dest"
tmpv="/tmp/preseed/${filename%.*}/vm"

aptinstall syslinux mtools mbr genisoimage dvd+rw-tools

dfx mkdir -p "$tmps"
dfx mkdir -p "$tmpd"
dfx mkdir -p "$tmpv"

if [ ! "$skipbuild" ]; then
    build
fi
if [ "$vbox" ]; then
    launch
fi

dfout1 "Finished"

