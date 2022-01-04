# Installtion

``` nix
nix-shell -p nixUnstable git
nixos-install --root /mnt --flake ~/dotworld/#yoga --impure --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"
```

# Hardware

``` shell
ext4 option "noatime" "nodiratime"
btrfs option "compress=zstd" "autodefrag" "noatime"

mkfs.btrfs -L nixos /dev/nvme0n1p3
mount /dev/nvme0n1p3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@home
umount /mnt
mount -o subvol=@,compress-force=zstd,noatime,autodefrag /dev/nvme0n1p3 /mnt
mkdir -p /mnt/{boot,nix,home}
mount -o subvol=@nix,compress-force=zstd,noatime,autodefrag /dev/nvme0n1p3 /mnt/nix
mount -o subvol=@home,compress-force=zstd,noatime,autodefrag /dev/nvme0n1p3 /mnt/home
```
[NixOS on btrfs](https://litschi.dev/posts/nixos-on-btrfs/)

# Desktop Setup

``` shell
# force en home directory
LC_ALL=C xdg-user-dirs-update --force

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
