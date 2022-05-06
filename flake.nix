{
  description = "Hello world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs.url = "git+file:///home/iab/devel/nixpkgs";
    local-nixpkgs.url = "git+file:///home/iab/devel/nixpkgs";

    nixos-hardware.url = github:NixOS/nixos-hardware/master;

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # devshell.url = "github:numtide/devshell";
    musnix.url = github:musnix/musnix;

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
    local-nixpkgs,
    nixos-hardware,
    home-manager,
    nur,
    musnix,
    emacs-overlay,
    ...
  }: let
    hosts = "yoga";
    hosts-2 = "svp";
    username = "iab";
  in {
    overlays.default = import ./overlays;

    nixosConfigurations.${hosts} = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs username;};
      system = "x86_64-linux";
      modules = [
        {networking.hostName = "${hosts}";}
        ./hosts/yoga/hardware-configuration.nix
        nixos-hardware.nixosModules.common-pc-laptop-ssd
        nixos-hardware.nixosModules.common-gpu-amd

        ./modules/base.nix
        ./modules/network.nix
        ./modules/nixconfig.nix
        # =====================
        ./modules/fonts.nix
        ./modules/virtual.nix
        ./modules/user.nix
        ./modules/gnome.nix
        # ./modules/kde.nix

        {
          nixpkgs.overlays = [
            (final: prev: {
              local = local-nixpkgs.legacyPackages.${prev.system};
            })
            self.overlays.default
            nur.overlay
            emacs-overlay.overlay
          ];
        }
        ./overlays/v2raya/v2raya.nix

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
            ./home-manager/gtk.nix
          ];
        }
      ];
    };

    # nixosConfigurations.${hosts-2} = nixpkgs.lib.nixosSystem {
    #   specialArgs = {inherit inputs username hosts-2;};
    #   system = "x86_64-linux";
    #   modules = [];
    # };

    # nix build nixosConfigurations.vm.config.system.build.vm
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [
        ({pkgs, ...}: {
          # disabledModules = ["services/desktops/pipewire/pipewire.nix"];
          imports = [
            "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
            # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
          ];

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
