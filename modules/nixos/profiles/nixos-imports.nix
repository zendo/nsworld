{ config, ... }:
{
  flake.modules.nixos.default-imports.imports = with config.flake.modules.nixos; [
    mods
    secrets

    # [ shell ]
    fish
    zsh

    # [ core ]
    base
    boot
    fonts
    keyboards
    ssh
    # gpg
    user

    # [ networking ]
    bittorrent
    dns
    firewall
    networkmanager
    # print

    # [ nix ]
    nix-cache
    nixconfig
    nixpkgs

    # [ desktop ]
    # [ profiles ]
    # [ virt ]
  ];
}
