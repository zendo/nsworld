[![ci-badge](https://img.shields.io/static/v1?label=Built%20with&message=nix&color=blue&style=flat&logo=nixos&link=https://nixos.org&labelColor=111212)](https://nixos.org/)
[![garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fzendo%2Fnsworld%3Fbranch%3Dmain)](https://garnix.io/repo/zendo/nsworld)

# Installation

```shell
mkfs.fat -F32 /dev/nvme0n1p3
mkswap /dev/nvme0n1p4
swapon /dev/nvme0n1p4
bcachefs format /dev/nvme0n1p5
mount /dev/nvme0n1p5 /mnt
mkdir /mnt/efi
mount /dev/nvme0n1p1 /mnt/efi
nixos-generate-config --flake --root /mnt

disko -m disko hosts/rmt/disko-bcachefs.nix
nixos-generate-config --no-filesystems --flake --root /mnt

nixos-anywhere \
  # --disko-mode mount \
  --no-substitute-on-destination \
  --flake .#rmt \
  root@192.168.122.25

nixos-install \
  --no-root-passwd \
  --option substituters "https://mirror.sjtu.edu.cn/nix-channels/store" \
  --flake .#host
```

[SrvOS](https://github.com/nix-community/srvos)

[Mic92](https://github.com/Mic92/dotfiles)

[thiagokokada](https://github.com/thiagokokada/nix-configs)

# Nix Commands

```shell
# Developer Environments
nix develop --no-write-lock-file github:nix-community/nix-environments#openwrt
nix flake init -t github:MordragT/nix-templates#tauri
```

# Nix Lang

[Nix one pager](https://github.com/tazjin/nix-1p)

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
