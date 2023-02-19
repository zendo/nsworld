inputs: let
  inherit (inputs) self nixpkgs nixpkgs-stable home-manager;
in
  {
    username,
    nixpkgs ? inputs.nixpkgs,
    system ? "x86_64-linux",
    overlays ? [],
    extraModules ? [],
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      modules =
        [
          ../home-manager/cli.nix
          ../home-manager/git.nix
          ../home-manager/zsh.nix
          ../home-manager/xdg.nix
          ../home-manager/tmux.nix
          ../home-manager/alias.nix
          ../home-manager/non-nixos.nix

          {
            home.stateVersion = "22.05";
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
          }
        ]
        ++ extraModules;
    }
