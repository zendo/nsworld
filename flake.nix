{
  description = "Zendo NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix.url = "github:ryantm/agenix";

    # Real-time audio
    musnix.url = github:musnix/musnix;

    # Easy access to development environments.
    # devshell.url = "github:numtide/devshell";

    # flake-utils.url = "github:numtide/flake-utils";
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };


    emacs-overlay.url = "github:nix-community/emacs-overlay/7ba0cd76c4e5cbd4a8ac7387c8ad2493caa800f0";

    nur.url = "github:nix-community/NUR";
    # nixos-cn.url = "github:nixos-cn/flakes";
  };

  outputs =
    inputs@
    { self
    , nixpkgs
    , nixpkgs-unstable
    , nixos-hardware
    , home-manager
    , utils
    , musnix
    , nur
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

      overlay = import ./overlays;

      # Overlays which are applied to all channels.
      sharedOverlays = [
        # (final: prev: {
        #   unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        # })
        self.overlay
        nur.overlay
        emacs-overlay.overlay
      ];

      hostDefaults = {
        system = "x86_64-linux";
        # channelName = "nixpkgs-unstable";
        # Extra arguments to be passed to all modules. Merged with host's extraArgs.
        # extraArgs = { inherit utils inputs; foo = "foo"; };
        modules = [
          ./modules/nixconfig.nix
          ./modules/configuration.nix
          ./modules/network.nix
          musnix.nixosModules.musnix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.iab = import ./homefiles/home.nix;
            # home-manager.users.zen = import ./homefiles/home.nix;
          }

          {
            nix.generateNixPathFromInputs = true;
            nix.generateRegistryFromInputs = true;
          }
        ];
      };

      hosts.yoga.modules = [
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-gpu-amd
        # ./modules/kde.nix
        ./modules/gnome.nix
        ./modules/locale-cn.nix
        ./hosts/yoga/user.nix
        ./hosts/yoga/user-2.nix
        ./hosts/yoga/hardware-configuration.nix
      ];

      hosts.svp.modules = [
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-cpu-intel
        ./modules/kde.nix
        #./modules/gnome.nix
        ./modules/locale-cn.nix
      ];

    };
}
