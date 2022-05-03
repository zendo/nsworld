{
  description = "Zendo NixOS world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    local-nixpkgs.url = "git+file:///home/iab/devel/nixpkgs";

    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;

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

    emacs-overlay.url = "github:nix-community/emacs-overlay/2191e9676590a1220683cceabaf9bf07da145a0c";

    nur.url = "github:nix-community/NUR";
    # nixos-cn.url = "github:nixos-cn/flakes";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    local-nixpkgs,
    nixos-hardware,
    home-manager,
    utils,
    nur,
    musnix,
    emacs-overlay,
    ...
  }:
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
        (final: prev: {
          local = local-nixpkgs.legacyPackages.${prev.system};
        })
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
          ./overlays/v2raya/v2raya.nix
        ];
      };

      hosts.yoga.modules = [
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-gpu-amd
        ./hosts/yoga/hardware-configuration.nix

        ./modules/fonts.nix
        ./modules/virtual.nix
        ./modules/user.nix
        # ./modules/gnome.nix
        ./modules/kde.nix

        musnix.nixosModules.musnix
        {musnix.enable = true;}

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.extraSpecialArgs = { inherit self inputs; };
          home-manager.users.iab.imports = [
            ./home-manager/git.nix
            ./home-manager/cli.nix
            ./home-manager/zsh.nix
            ./home-manager/xdg.nix
            ./home-manager/alias.nix
            ######## wsl #########
            ./home-manager/gui.nix
            ./home-manager/editor.nix
            # ./home-manager/gtk.nix
          ];
        }
      ];

      hosts.svp.modules = [
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-cpu-intel
        ./hosts/svp/hardware-configuration.nix

        ./modules/fonts.nix
        ./modules/virtual.nix
        ./modules/user.nix
        ./modules/kde.nix
        # ./modules/gnome.nix
      ];
    };
}
