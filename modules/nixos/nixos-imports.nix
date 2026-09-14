{ config, ... }:
{
  flake.modules.nixos.nixos-imports.imports = with config.flake.modules.nixos; [
    mods
    secrets

    # [ shell ]
    alias
    bash
    fish
    zsh
    terminal
    env

    # [ core ]
    base
    boot
    fonts
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
    nix-tools
    nixconfig
    nixpkgs

    # [ programs ]
    chrome
    firefox

    # [ services ]
    # bittorrent
    emacs
    # kanata
    keyd

    # [ desktop ]
    # [ profiles ]
    # [ virt ]
  ];
}
