#! /usr/bin/env bash

# print command before executing, and exit when any command fails
set -xe

### Update the system clock
timedatectl set-ntp true

### Mirror
sed -i '1i Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist
sed -i '1i Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist

### BootStrap
pacstrap /mnt base base-devel linux-zen linux-firmware efibootmgr bash-completion
echo "BootStarp Done!"
