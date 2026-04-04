{ config, ... }:
{
  flake.modules.nixos.default-imports.imports = with config.flake.modules.nixos; [
    # [ core ]
    base
    boot
    fonts
    nixconfig
    nixpkgs
    ssh
    # gpg
    user

    mods

    # [ networking ]
    dns
    firewall
    networkmanager
    # print

    services

    # [ shell ]
    # fish
    zsh

    secrets
  ];
}
