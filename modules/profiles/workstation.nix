{ config, ... }:
{
  flake.modules.nixos.workstation = {
    imports = with config.flake.modules.nixos; [
      myvars
      # secrets

      programs
      services
      selfhosted

      # [ core ]
      base
      boot
      fonts
      ssh
      ssh-hosts
      # gpg
      user

      # [ desktop ]

      # [ networking ]
      dns
      # avahi
      firewall
      # samba
      # tailscale

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

      # [ shell ]
      alias
      bash
      # fish
      # zsh
      terminal

      # [ virt ]

      # [ xdg ]
      data-center
      env
      mime
    ];
  };
}
