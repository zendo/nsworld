# Installtion

``` shell
mkfs.fat -F 32 /dev/nvme0n1p3
mkswap swap /dev/nvme0n1p4
swapon /dev/nvme0n1p4
mkfs.btrfs /dev/nvme0n1p5
nixos-generate-config --root /mnt
nixos-install --flake .#yoga --no-root-passwd --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org"
```

[Config Example](https://github.com/thiagokokada/nix-configs)

[FUP Example](https://github.com/jakehamilton/config)

# Nix Commands

``` shell
# make livecd
nixos-generate -f iso -c ~/.nsworld/modules/iso.nix

# Developer Environments
nix develop --no-write-lock-file github:nix-community/nix-environments#openwrt
nix shell github:oxalica/rust-overlay

# shebangs for NixOS/BSD
#!/usr/bin/env bash
```

# Desktop Setup

``` shell
# force using en directorys
LC_ALL=C xdg-user-dirs-update --force

# Emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d

# Backup Gnome Settings
dconf dump /org/gnome/ > my-dconf
dconf load /org/gnome/ < my-dconf
dconf dump /org/gnome/ | dconf2nix > ~/.nsworld/home-manager/dconf.nix

# Backup KDE Settings
curl https://gitlab.com/cscs/transfuse/-/raw/master/transfuse.sh -o ~/.local/bin/kde-backup ; chmod +x $_

# RIME
curl -fsSL https://git.io/rime-install | rime_dir="$HOME/.local/share/fcitx5/rime" Plus Below
bash -s -- :preset
bash -s -- rime-install BlindingDark/rime-easy-en:customize:schema=luna_pinyin

# Clover
curl -s https://api.github.com/repos/fkxxyz/rime-cloverpinyin/releases/latest | grep "browser_download_url.*build.*" | cut -d '"' -f 4 | xargs -n 1 curl -LJO
```

# Nix Lang

[Learn Nix in minutes](https://learnxinyminutes.com/docs/nix/)

[Nix one pager](https://github.com/tazjin/nix-1p)

[Nix by example](https://medium.com/@MrJamesFisher/nix-by-example-a0063a1a4c55)

[Intro Nix Family](https://web.archive.org/web/20210123223258/https://ebzzry.io/en/nix/)

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

