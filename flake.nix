{
  description = "Hello world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs.url = "git+file:///home/iab/devel/nixpkgs";
    local.url = "git+file:///home/iab/devel/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = github:edolstra/flake-compat;
      flake = false;
    };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # devshell.url = "github:numtide/devshell";
    musnix.url = github:musnix/musnix;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    templates.url = github:NixOS/templates;

    nur.url = "github:nix-community/NUR";
    # nixos-cn.url = "github:nixos-cn/flakes";
    emacs-overlay.url = "github:nix-community/emacs-overlay/334ba8c610cf5e41dfe130507030e5587e3551b4";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    local,
    home-manager,
    nixos-hardware,
    templates,
    nur,
    musnix,
    emacs-overlay,
    ...
  }: let
    commonFeatures = [
      ./modules/base.nix
      ./modules/user.nix
      ./modules/network.nix
      ./modules/nixconfig.nix
    ];

    overlayFeatures = [
      {
        nixpkgs.overlays = [
          nur.overlay
          emacs-overlay.overlay
          (import ./overlays)
          (final: prev: {
            local = local.legacyPackages.${prev.system};
          })
        ];
      }
    ];
  in {
    #############################################
    nixosConfigurations.yoga = let
      username = "iab";
    in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs username;};
        modules =
          commonFeatures
          ++ overlayFeatures
          ++ [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-gpu-amd
            ./hosts/yoga/hardware-configuration.nix
            {networking.hostName = "yoga";}

            ./modules/sound.nix
            ./modules/fonts.nix
            ./modules/virtual.nix
            # ./modules/gnome.nix
            ./modules/kde.nix

            ./overlays/v2raya/v2raya.nix
            # {services.v2raya.enable = true;}

            musnix.nixosModules.musnix
            {musnix.enable = true;}

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # home-manager.extraSpecialArgs = { inherit self inputs; };
              home-manager.users.${username}.imports = [
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
      };

    #############################################
    nixosConfigurations.svp = let
      username = "zendo";
    in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs username;};
        modules =
          commonFeatures
          ++ overlayFeatures
          ++ [
            nixos-hardware.nixosModules.common-pc-laptop-ssd
            nixos-hardware.nixosModules.common-cpu-intel
            ./hosts/svp/hardware-configuration.nix
            {networking.hostName = "svp";}

            ./modules/sound.nix
            ./modules/fonts.nix
            ./modules/gnome.nix
            # ./modules/kde.nix
            ./modules/virtual.nix
          ];
      };

    #############################################
    # nix build .#nixosConfigurations.vm.config.system.build.vm
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ({pkgs, ...}: {
          # disabledModules = ["services/desktops/pipewire/pipewire.nix"];
          imports = [
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
            # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
            ./modules/base.nix
            ./modules/network.nix
            ./modules/nixconfig.nix
            ./modules/sound.nix
            ./modules/gnome.nix
          ];

          services.xserver.displayManager.autoLogin.user = "user";

          virtualisation = {
            memorySize = 1024 * 3;
            diskSize = 1024 * 8;
            cores = 4;
            msize = 104857600;
          };

          users.users.root = {
            password = "root";
          };
          users.users.user = {
            password = "user";
            isNormalUser = true;
            extraGroups = ["wheel"];
          };
        })
      ];
    };
  };
}
