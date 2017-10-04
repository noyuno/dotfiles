# install.sh

## Commands

sudo bash install.sh STORAGE_DEVICE ROOT_PARTITION_SIZE
    Install new system partitions and luks system.
    Example: sudo bash install.sh /dev/sda 20G

sudo bash install.sh luks USB_DEVICE
    Create luks unlock USB.
    Example: sudo bash install.sh luks /dev/sdb1

## Guide

    0. Boot installer
    1. Create partitions and encrypt /home. Type `sudo bash install.sh /dev/sda 20G`
    2. Double click 'Install Ubuntu MATE' on desktop icon to install system.
    3. Create luks unlock USB. Type `sudo bash install.sh luks /dev/sdb1`
    4. Reboot system.

## Layout

    -----------------------------------------------------
    | device   | sda1      | sda2             | sda3    |
    | manage   |           | lvm(vg0)         | bios    |
    | lv       |           | lv0   | lv1      |         |
    | crypto   |           |       | luks     |         |
    | format   | fat32     | ext4  | ext4     | ef02    |
    | mount on | /boot/efi | /     | /home    |         |
    | size     | 100MB     | 100GB | 100%free | 1007KiB |
    -----------------------------------------------------

More information available at: [dm-cryptを使った/homeの暗号化とUSBでの解錠 – blog – noyuno](https://noyuno.github.io/blog/2017/04/09/crypto/)

