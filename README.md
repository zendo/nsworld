[![NixOS Logo](https://img.shields.io/badge/NixOS-white?style=plat-square&logo=nixos&logoColor=5277C3)](https://shields.io/)
[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org)
![Size](https://img.shields.io/github/repo-size/zendo/nsworld?color=red&label=size&style=plat-square)

# Installation

``` shell
mkfs.fat -F32 /dev/nvme0n1p3
mkswap /dev/nvme0n1p4
swapon /dev/nvme0n1p4
mkfs.btrfs /dev/nvme0n1p5
mkdir -p /mnt/boot/efi

nixos-generate-config --root /mnt
nixos-install --flake .#yoga --no-root-passwd
--option substituters "https://cache.nixos.org"
--option substituters "https://mirror.sjtu.edu.cn/nix-channels/store"
```

[Config Example](https://github.com/thiagokokada/nix-configs)

[More Example](https://github.com/foo-dogsquared/nixos-config)

[FUP Example](https://github.com/jakehamilton/config)

# Nix Commands

``` shell
# Developer Environments
nix develop --no-write-lock-file github:nix-community/nix-environments#openwrt
nix develop 'github:the-nix-way/nix-flake-dev-environments?dir=rust'
go/rust/python/java/node/php/ruby-on-rails
```

# Desktop Setup

``` shell
# WSL
wsl --import nixos .\nixos\ nixos-wsl-installer.tar.gz --version 2
wsl -d nixos
wsl --unregister nixos
```

# Nix Lang

<!-- <img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg" align="right" alt="Nix logo" width="150"> -->

[Nix Builtins](https://devdocs.io/nix/)

[Nix one pager](https://github.com/tazjin/nix-1p)

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

