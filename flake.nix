{
  description = "NIX SAVE THE WORLD";

  outputs =
    inputs@{ self, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        ./hosts/flake-module.nix
        ./nixos/flake-module.nix
        ./overlays/flake-module.nix
        ./home-manager/hm-standalone.nix
        ./hosts/deployment.nix
        ./lib/flake-module.nix
        ./lib/repl.nix
        ./templates/flake-module.nix
        # inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          inputs',
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
              # allowBroken = true;
              # allowInsecure = true;
              # allowUnsupportedSystem = true;
              android_sdk.accept_license = true;
            };
          };

          # access pkgs from self & overlays
          legacyPackages = pkgs;

          packages =
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./pkgs;
            }
            // {
              # nix run .
              default = config.packages.azcomicv;
            };

          # nix fmt
          formatter = pkgs.nixfmt-rfc-style;

          # nix develop .#rust
          devShells = import ./devshells.nix { inherit pkgs; };
        };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-temp.url = "github:NixOS/nixpkgs/5a8e9243812ba528000995b294292d3b5e120947";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/pull/213619/merge";
    # nixpkgs.url = "git+file:///home/iab/dev/nixpkgs/?ref=pr-358877-clash-rev";

    home-manager = {
      url = "github:nix-community/home-manager";
      # url = "git+file:///home/iab/dev/home-manager/?ref=fix/emacs";
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

    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur.url = "github:nix-community/NUR";
    # agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    templates.url = "github:NixOS/templates";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  # auto-fetch deps when `nix run/shell/develop`
  nixConfig = {
    # bash-prompt = "[nix]λ ";
    # substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
    # extra-substituters = ["https://nix-gaming.cachix.org"];
    # extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
}
