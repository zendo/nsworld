# Installtion

``` nix
nixos-install --root /mnt --flake ~/dotworld/#yoga --impure --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"
```

# Hardware

``` nix
ext4 option "noatime" "nodiratime"
btrfs option "compress=zstd" "autodefrag" "noatime"
```

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

