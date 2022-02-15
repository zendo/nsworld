# Installtion

``` shell
git clone git@github.com:zendo/nsworld.git
nixos-install --flake .#yoga --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"
```

[Flake Example](https://github.com/arnarg/config)

# Nix Commands

``` shell
# make livecd
nixos-generate -f iso -c ~/nsworld/modules/iso.nix

# Developer Environments
nix develop --no-write-lock-file github:nix-community/nix-environments#openwrt

# shebangs for NixOS/BSD
#!/usr/bin/env bash
```

# Desktop Setup

``` shell
# force using en home-directorys
LC_ALL=C xdg-user-dirs-update --force

# rime
sh ~/nsworld/others/rime/ln_ibus.sh

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
org.gnome.settings-daemon.plugins.power hibernate
```

# Nix Lang

[Learn Nix in minutes](https://learnxinyminutes.com/docs/nix/)

[Nix one pager](https://github.com/tazjin/nix-1p)

[Nix by example](https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55)

[Intro Nix Family](https://web.archive.org/web/20210123223258/https://ebzzry.io/en/nix/)

[Nix builtins functions](https://teu5us.github.io/nix-lib.html)
