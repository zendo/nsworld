{
  description = "Zendo NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Managing your secrets.
    agenix.url = "github:ryantm/agenix";

    # Real-time audio
    musnix.url = github:musnix/musnix;

    # Easy access to development environments.
    # devshell.url = "github:numtide/devshell";

    # flake-utils.url = "github:numtide/flake-utils";
    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    emacs-overlay.url = "github:nix-community/emacs-overlay";

    nur.url = "github:nix-community/NUR";
    # nixos-cn.url = "github:nixos-cn/flakes";
  };

  outputs =
    inputs@
    { self
    , nixpkgs
    , nixpkgs-unstable
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

      # Overlays which are applied to all channels.
      sharedOverlays = [
        (final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        })
        emacs-overlay.overlay
        nur.overlay
      ];

      overlays = [
        # import ./overlays;
      ];

      hostDefaults = {
        system = "x86_64-linux";
        # channelName = "nixpkgs-unstable";
        # Extra arguments to be passed to all modules. Merged with host's extraArgs.
        # extraArgs = { inherit utils inputs; foo = "foo"; };
      };

      # Modules shared between all hosts
      hostDefaults.modules = [
        ./modules/nixconfig.nix
        ./modules/configuration.nix
        ./modules/network.nix
        musnix.nixosModules.musnix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.iab = import ./hmwork/home.nix;
        }
      ];

      hosts.yoga.modules = [
        ./modules/amd.nix
        # ./modules/kde.nix
        ./modules/gnome.nix
        ./modules/locale-cn.nix
        ./hosts/yoga/user.nix
        ./hosts/yoga/user-2.nix
        ./hosts/yoga/hardware-configuration.nix
      ];
    };
}
