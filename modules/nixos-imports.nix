{ config, ... }:
{
  flake.modules.nixos.nixos-imports.imports = with config.flake.modules.nixos; [
    secrets

    # [ core ]
    base
    boot
    fonts
    ssh
    # gpg
    user

    # [ desktop ]

    mods

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

    # [ profiles ]

    # [ services ]
    # bittorrent
    emacs
    # kanata
    keyd

    # [ shell ]
    alias
    bash
    fish
    zsh
    terminal

    # [ virt ]

    # [ xdg ]
    env
    mime
  ];
}
