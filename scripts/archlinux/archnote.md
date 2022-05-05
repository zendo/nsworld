# Network

- dhcpcd  有线

ping www.baidu.com

- 无线  iwctl

station wlan0 get-networks

station wlan0 connect SSID

# Installtion
``` shell
mkfs.ext4
mkdir /boot/efi
mount rootfs & esp
sh 1install.sh

cp -r /run/archiso/bootmenu/dotworld/others/archlinux /mnt
genfstab -U /mnt /mnt/boot/efi >> /mnt/etc/fstab
arch-root /mnt
sh 2install.sh

vi /etc/resolv.conf
nameserver 114.114.114.114
sh 3install.sh
```

## 驱动

21.1) AMD: sudo pacman -S mesa xf86-video-ati xf86-video-amdgpu vulkan-radeon amd-ucode

21.2) Intel: sudo pacman -S mesa xf86-video-intel vulkan-intel intel-ucode

21.3) NVIDIA: sudo pacman -S mesa nvidia xf86-video-nouveau nvidia-utils

# 参考链接

简单中文安装脚本：
https://github.com/bianjp/archlinux-installer

复杂通用型安装脚本：
https://github.com/helmuthdu/aui
https://gitee.com/auroot/arch_wiki


# 一些技巧
sudo sed -i '1i Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist

sudo sed -i 's/^# %wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL/' /etc/sudoers
