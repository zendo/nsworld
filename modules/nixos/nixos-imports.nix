{ config, ... }:
{
  flake.modules.nixos.nixos-imports.imports = with config.flake.modules.nixos; [
    mods
    secrets

    # [ shell ]
    # fish
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
    dns
    firewall
    networkmanager
    # print

    # [ nix ]
    # nix-cache
    nixconfig
    nixpkgs

    # [ programs ]
    chrome
    firefox

    # [ services ]
    # bittorrent
    emacs

    # [ desktop ]
    # [ profiles ]
    # [ virt ]
  ];
}
