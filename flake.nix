{
  description = "NIX SAVE THE WORLD";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./modules/flake/flake-parts.nix # flake.packages / perSystem
        ./modules/flake/devshell.nix # flake.devshells
        ./modules/flake/treefmt.nix # flake.formatter
        ./modules/flake/templates # flake.templates
        ./modules/nixos # flake.nixosModules
        ./modules/lib # flake.lib
        ./overlays # flake.overlays
        ./hosts # flake.nixosConfigurations
        ./hosts/deployment.nix # flake.deploy / flake.colmena
        ./modules/home/hm-as-standalone.nix # flake.homeConfigurations
      ];
    };

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    # nvf.url = "github:notashelf/nvf";
    nix-alien.url = "github:thiagokokada/nix-alien";
    disko.url = "github:nix-community/disko";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs"; # remove when colmena release
    deploy-rs.url = "github:serokell/deploy-rs";
    plasma-manager.url = "github:nix-community/plasma-manager";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    templates.url = "github:NixOS/templates";
    # import-tree.url = "github:vic/import-tree";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
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
