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
    cli
    gui
    chrome
    firefox

    # [ services ]
    # bittorrent
    emacs
    # kanata
    keyd

    # [ xdg ]
    env
    mime

    # [ desktop ]
    # [ profiles ]
    # [ virt ]
  ];
}
