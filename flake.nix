{
  description = "NIX SAVE THE WORLD";

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        ./hosts/flake-module.nix # flake.nixosConfigurations
        ./nixos/flake-module.nix # flake.nixosModules
        ./overlays/flake-module.nix # flake.overlays
        ./home-manager/hm-as-standalone.nix # flake.homeConfigurations
        ./hosts/deployment.nix # flake.deploy
        ./lib/flake-module.nix # flake.lib
        ./templates/flake-module.nix # flake.templates
        ./devshells/flake-module.nix # flake.devShells
        ./devshells/treefmt.nix # flake.formatter
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          lib,
          pkgs,
          config,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ self.overlays.modifications ];
            config = {
              allowUnfree = true;
              # allowInsecure = true;
              android_sdk.accept_license = true;
            };
          };

          # quickly access nixpkgs packages without specifying `legacyPackages.<arch>`
          legacyPackages = pkgs;

          packages =
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./overlays/pkgs;
            }
            // {
              # nix run .
              default = config.packages.anich;
            };
        };

      debug = true;
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable-small/nixexprs.tar.xz";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs.url = "git+file:///home/iab/code/nixpkgs/?ref=pr-throne-430949";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur.url = "github:nix-community/NUR";
    # agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    # nvf.url = "github:notashelf/nvf";
    templates.url = "github:NixOS/templates";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
