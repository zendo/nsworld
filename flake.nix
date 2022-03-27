{
  description = "Zendo NixOS Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = github:ryantm/agenix;

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

    emacs-overlay.url = "github:nix-community/emacs-overlay/d43b200ed5675bf912440975435dd7a7363f9481";

    nur.url = "github:nix-community/NUR";
    # nixos-cn.url = "github:nixos-cn/flakes";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    utils,
    musnix,
    nur,
    emacs-overlay,
    ...
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
          ./modules/base.nix
          ./modules/network.nix
          ./modules/nixconfig.nix
        ];
      };

      hosts.yoga.modules = [
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-gpu-amd
        # ./modules/kde.nix
        ./modules/gnome.nix
        ./modules/chinese.nix
        ./hosts/yoga/user.nix
        ./hosts/yoga/hardware-configuration.nix

        musnix.nixosModules.musnix
        {musnix.enable = true;}

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.iab = {...}: {
            home.stateVersion = "22.05";
            programs.home-manager.enable = true;
            imports = [
              ./dotfiles/hm-pkgs.nix
              ./dotfiles/hm-cli.nix
              ./dotfiles/hm-gui.nix
              ./dotfiles/hm-gnome.nix
              # ./dotfiles/hm-dconf.nix
            ];
          };
        }
      ];

      hosts.svp.modules = [
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-cpu-intel
        ./modules/kde.nix
        #./modules/gnome.nix
        ./modules/chinese.nix
      ];
    };
}
