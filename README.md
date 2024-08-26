[![NixOS Logo](https://img.shields.io/badge/NixOS-white?style=plat-square&logo=nixos&logoColor=5277C3)](https://shields.io/)
[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
![Size](https://img.shields.io/github/repo-size/zendo/nsworld?color=red&label=size&style=plat-square)

# Installation

``` shell
mkfs.fat -F32 /dev/nvme0n1p3
mkswap /dev/nvme0n1p4
swapon /dev/nvme0n1p4
bcachefs format /dev/nvme0n1p5
mount /dev/nvme0n1p5 /mnt
mkdir /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
nixos-generate-config --root /mnt

nix run github:nix-community/disko -- -m disko hosts/rmt/disko-bcachefs.nix
nixos-generate-config --no-filesystems --root /mnt

nix run github:nix-community/nixos-anywhere -- --flake .#rmt root@192.168.122.89 --no-substitute-on-destination

nixos-install --no-root-passwd --flake .#host
--option substituters "https://cache.nixos.org"
--option substituters "https://mirror.sjtu.edu.cn/nix-channels/store"
```

[Config Example](https://github.com/thiagokokada/nix-configs)

[More Example](https://github.com/foo-dogsquared/nixos-config)

# Nix Commands

``` shell
# Developer Environments
nix develop --no-write-lock-file github:nix-community/nix-environments#openwrt
nix flake init -t github:github:MordragT/nix-templates#tauri
```

# Nix Lang

<!-- <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" align="right" alt="Nix logo" width="150"> -->

[Nix one pager](https://github.com/tazjin/nix-1p)

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

