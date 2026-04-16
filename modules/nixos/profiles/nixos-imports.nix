{ config, ... }:
{
  flake.modules.nixos.default-imports.imports = with config.flake.modules.nixos; [
    secrets

    # [ shell ]
    fish
    zsh

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

    # [ services ]
    dae # services.daeWithConfig
    kanata
    # keyd
    sub-store # systemd.services.sub-store

    # [ desktop ]
    # [ profiles ]
    # [ virt ]
  ];
}
