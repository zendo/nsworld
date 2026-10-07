{ config, ... }:
{
  flake.modules.nixos.nixos-imports.imports = with config.flake.modules.nixos; [
    # secrets # Go 1.25 EOL

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
    emacs
    chrome
    firefox

    # [ profiles ]

    # [ services ]
    # bittorrent
    # kanata
    keyd

    # [ shell ]
    alias
    bash
    # fish
    zsh
    terminal

    # [ virt ]

    # [ xdg ]
    env
    mime
  ];
}
