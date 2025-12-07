{
  description = "NIX SAVE THE WORLD";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        ./lib # flake.lib
        ./overlays # flake.overlays
        ./nixos # flake.nixosModules
        ./hosts # flake.nixosConfigurations
        ./templates # flake.templates
        ./devshells/treefmt.nix # flake.formatter
        ./hosts/deployment.nix # flake.deploy / flake.colmena
        ./home-manager/hm-as-standalone.nix # flake.homeConfigurations
      ];

      debug = true; # repl: flake.currentSystem / flake.debug

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          lib,
          pkgs,
          system,
          config,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ inputs.self.overlays.modifications ];
            config = {
              allowUnfree = true;
              # allowInsecure = true;
              android_sdk.accept_license = true;
            };
          };

          # nix build .#
          # quickly access nixpkgs packages without specifying `legacyPackages.<arch>`
          legacyPackages = pkgs;

          # flake.packages
          packages =
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./pkgs;
            }
            // {
              # nix run .
              default = config.packages.anich;
            };

          # nix develop .#rust
          devShells = import ./devshells { inherit pkgs; };
        };
    };

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    # nixpkgs.url = "git+file:///home/iab/code/nixpkgs/?ref=pr-throne-430949";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia = {
    #   url = "github:noctalia-dev/noctalia-shell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # emacs-overlay = {
    #   url = "github:nix-community/emacs-overlay";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nur.url = "github:nix-community/NUR";
    # agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    # nvf.url = "github:notashelf/nvf";
    disko.url = "github:nix-community/disko";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs"; # remove when colmena release
    deploy-rs.url = "github:serokell/deploy-rs";
    nix-alien.url = "github:thiagokokada/nix-alien";
    plasma-manager.url = "github:nix-community/plasma-manager";
    templates.url = "github:NixOS/templates";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  # Flake Local Nix Configuration
  nixConfig = {
    # bash-prompt = "[nix]λ ";
    # substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    # extra-substituters = [ "https://cache.garnix.io" ];
    # extra-trusted-public-keys = [
    #   "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    # ];
  };
}
