{ config, ... }:
{
  flake.modules.nixos.default-imports.imports = with config.flake.modules.nixos; [
    secrets

    # [ shell ]
    fish
    # zsh

    # [ core ]
    base
    boot
    fonts
    keyboards
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

    # [ desktop ]
    # [ profiles ]
    # [ virt ]
  ];
}
