{
  description = "Yoga14s NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Managing your secrets.
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Easy access to development environments.
    # devshell.url = "github:numtide/devshell";

    # nur.url = "github:nix-community/NUR";
    # nur.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-cn.url = "github:nixos-cn/flakes";
    # nixos-cn.inputs.nixpkgs.follows = "nixpkgs";

    # flake-utils.url = "github:numtide/flake-utils";
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs =
    inputs@
    { self
    , nixpkgs
    , home-manager
    , utils
    , emacs-overlay
    , ...
    }:

    utils.lib.mkFlake {
      inherit self inputs;
      # supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        allowBroken = true;
        allowUnsupportedSystem = true;
      };

      sharedOverlays = [
      ];

      # custom overlays
      # overlay = import ./overlays;

      hostDefaults = {
        system = "x86_64-linux";
      };

      # Modules shared between all hosts
      hostDefaults.modules = [
        ./modules/nix-config.nix
        ./modules/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.iab = import ./hmwork/home.nix;
        }
      ];

      hosts.yoga.modules = [
        ./modules/amd.nix
        ./hosts/yoga/hardware-configuration.nix
        ./hosts/yoga/user.nix
        ./modules/gnome.nix
      ];
    };
}
