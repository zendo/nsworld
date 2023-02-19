inputs: let
  inherit (inputs) self nixpkgs nixpkgs-stable home-manager;
in
  {
    username,
    system ? "x86_64-linux",
    nixpkgs ? inputs.nixpkgs,
    overlays ? [],
    extraModules ? [],
  }:
  home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    modules = [
      ./home-manager/alias.nix
      ./home-manager/cli.nix
      ./home-manager/git.nix
      ./home-manager/zsh.nix
      ./home-manager/xdg.nix
      ./home-manager/tmux.nix
      ./home-manager/non-nixos.nix

      {
        home.stateVersion = "22.05";
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";
      }
    ] ++ extraModules;
  }
