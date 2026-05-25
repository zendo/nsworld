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
    ssh
    # gpg
    user

    mods

    # [ networking ]
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
