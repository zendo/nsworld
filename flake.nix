{
  description = "Zendo NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    , nixpkgs-unstable
    , home-manager
    , utils
    , emacs-overlay
    , ...
    }:

    # let
    #   pkgs = self.pkgs.x86_64-linux.nixpkgs;
    # in

    utils.lib.mkFlake {
      inherit self inputs;
      # supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        # allowBroken = true;
        # allowUnsupportedSystem = true;
      };

      # Overlays which are applied to all channels.
      sharedOverlays = [
        (final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        })
        emacs-overlay.overlay
      ];


      # overlay = import ./overlays;
      overlays = [
      ];

      hostDefaults = {
        system = "x86_64-linux";
      };

      # hostDefaults.channelName = "nixpkgs-unstable";

      # Extra arguments to be passed to all modules. Merged with host's extraArgs.
      # hostDefaults.extraArgs = { inherit utils inputs; foo = "foo"; };

      # Modules shared between all hosts
      hostDefaults.modules = [
        ./modules/nixconfig.nix
        ./modules/configuration.nix
        ./modules/network.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.iab = import ./hmwork/home.nix;
          # home-manager.sharedModules = [ ./programs doom.hmModule neomacs.hmModule ];
        }
      ];

      hosts.yoga.modules = [
        ./modules/amd.nix
        ./hosts/yoga/hardware-configuration.nix
        ./hosts/yoga/user.nix
        # ./modules/gnome.nix
         ./modules/kde.nix
      ];
    };
}
