{ config, ... }:
{
  flake.modules.nixos.default.imports = with config.flake.modules.nixos; [
    # [ core ]
    base
    boot
    fonts
    gpg
    graphical
    nixconfig
    nixpkgs
    ssh
    user

    mods

    # [ networking ]
    dns
    firewall
    networkmanager
    # print

    programs
    services

    # [ shell ]
    # fish
    zsh

    secrets
  ];
}
