# Installtion

``` nix
nix-shell -p nixUnstable git
nixos-install --root /mnt --flake github:zendo/dotworld#yoga --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"
```
[Starter Config](https://github.com/Misterio77/nix-starter-config/)

# Btrfs

``` shell
mkfs.btrfs -L nixos /dev/nvme0n1p5
mount /dev/nvme0n1p5 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap
umount /mnt
mount -o subvol=@,compress-force=zstd,noatime,autodefrag /dev/nvme0n1p5 /mnt
mkdir -p /mnt/{boot,nix,home,swap}

truncate -s 0 /mnt/swap/swapfile
chattr +C /mnt/swap/swapfile
btrfs property set /mnt/swap/swapfile compression none
# fallocate -l 16G /mnt/swapfile # if ext4
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count=18432
chmod 600 /swapfile
mkswap /mnt/swap/swapfile
swapon /mnt/swap/swapfile

mount -o subvol=@nix,compress-force=zstd,noatime,autodefrag /dev/nvme0n1p5 /mnt/nix
mount -o subvol=@home,compress-force=zstd,noatime,autodefrag /dev/nvme0n1p5 /mnt/home
mount -o subvol=@swap /dev/nvme0n1p5 /mnt/swap

ext4 option "noatime" "nodiratime"
btrfs option "compress=zstd" "autodefrag" "noatime"
```
[NixOS on btrfs](https://litschi.dev/posts/nixos-on-btrfs/)

# Desktop Setup

``` shell
# force en home directory
LC_ALL=C xdg-user-dirs-update --force

# flatpak useless
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
flatpak install Flatseal Spotify StandardNotes VideoTrimmer

# Backup KDE Settings
curl -O https://gitlab.com/cscs/transfuse/-/raw/master/transfuse.sh

# Backup Gnome Settings
dconf dump /org/gnome/ > my_gnome_settings
dconf reset -f /org/gnome/
dconf load /org/gnome/ < my_gnome_settings

# shebangs for NixOS/BSD
#!/usr/bin/env bash
```
