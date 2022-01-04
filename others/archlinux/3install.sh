#! /usr/bin/env bash

# print command before executing, and exit when any command fails
set -xe


### switch en temp
export LANG=en_us

### basic env
sudo pacman -S wayland libinput gnome gnome-tweaks seahorse gnome-power-manager firefox-i18n-zh-cn adobe-source-han-sans-cn-fonts ttf-hack a52dec libmad man-pages-zh_cn ibus-libpinyin v2ray
echo "Done"
sleep 3

sudo systemctl enable gdm.service


### arch-cn
sudo tee -a /etc/pacman.conf <<EOF

[archlinuxcn]
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/$arch
Server = https://repo.archlinuxcn.org/\$arch
EOF

sudo pacman -Syy && sudo pacman -S --noconfirm archlinuxcn-keyring
sudo pacman -S --noconfirm v2raya paru pamac
echo "Arch apps Done!"
sleep3



### Gnome

# No bell beep sound
gsettings set org.gnome.desktop.wm.preferences audible-bell false
