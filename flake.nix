{
  description = "Hello World";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs.url = "git+file:///home/iab/devel/nixpkgs";
    # local.url = "git+file:///home/iab/devel/nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/e8aa04eaa4cb8664a72191547fc2395dddd3c112";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-cn = {
    #   url = "github:nixos-cn/flakes";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # devshell.url = "github:numtide/devshell";
    nixos-wsl.url = github:nix-community/NixOS-WSL;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    musnix.url = github:musnix/musnix;
    templates.url = github:NixOS/templates;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # local,
    home-manager,
    flake-utils,
    emacs-overlay,
    nixos-hardware,
    templates,
    nur,
    musnix,
    nixos-wsl,
    ...
  }: let
    system = "x86_64-linux";

    commonFeatures = [
      ./modules/base.nix
      ./modules/user.nix
      ./modules/network.nix
      ./modules/nixconfig.nix
      ./modules/sound.nix
      ./modules/fonts.nix
      ./modules/virtual.nix
    ];

    pkgsOverlay = [
      {
        nixpkgs.overlays = [
          nur.overlay
          emacs-overlay.overlay
          (import ./overlays)
          # (final: prev: {
          #   local = local.legacyPackages.${prev.system};
          # })
        ];
      }
    ];
  in
    {
      #############################################
      nixosConfigurations.yoga = let
        username = "iab";
        hostname = "yoga";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs username;};
          modules =
            commonFeatures
            ++ pkgsOverlay
            ++ [
              nixos-hardware.nixosModules.common-pc-laptop-ssd
              nixos-hardware.nixosModules.common-gpu-amd
              ./hosts/yoga/hardware-configuration.nix
              # ./hosts/yoga/edid.nix
              {networking.hostName = "${hostname}";}

              ./modules/gnome.nix
              # ./modules/kde.nix

              ./overlays/v2raya/v2raya.nix
              # {services.v2raya.enable = true;}

              musnix.nixosModules.musnix
              {musnix.enable = true;}

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {inherit self inputs hostname;};
                home-manager.users.${username} = import ./home-manager;
              }
            ];
        };

      #############################################
      nixosConfigurations.svp = let
        username = "zendo";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs username;};
          modules =
            commonFeatures
            ++ pkgsOverlay
            ++ [
              nixos-hardware.nixosModules.common-pc-laptop-ssd
              nixos-hardware.nixosModules.common-cpu-intel
              ./hosts/svp/hardware-configuration.nix
              {networking.hostName = "svp";}

              ./modules/gnome.nix
              # ./modules/kde.nix
            ];
        };

      #############################################
      # nix build .#nixosConfigurations.wsl.config.system.build.installer
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          "${inputs.nixos-wsl}/configuration.nix"
          ./modules/nixconfig.nix
          ./hosts/wsl.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit self inputs;};
            home-manager.users.nixos.imports = [
              ./home-manager/git.nix
              ./home-manager/cli.nix
              ./home-manager/zsh.nix
              ./home-manager/alias.nix
            ];
          }
        ];
      };

      #############################################
      # home-manager build switch .#nixos --flake
      homeConfigurations = let
        username = "nixos";
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs system;
          username = "${username}";
          homeDirectory = "/home/${username}";
          stateVersion = "22.05";
          configuration = {
            imports = [
              ./home-manager/git.nix
              ./home-manager/cli.nix
              ./home-manager/zsh.nix
              ./home-manager/alias.nix
            ];
          };
        };
      };

      #############################################
      # nix build .#nixosConfigurations.vmtest.config.system.build.vmtest
      nixosConfigurations.vmtest = let
        username = "test";
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs username;};
          modules = [
            ./hosts/vmtest.nix
          ];
        };
    }
    // flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          allowUnfree = true;
          # allowBroken = true;
          # allowUnsupportedSystem = true;
        };
      in {
        # devShell = import ./shell.nix {inherit pkgs;};
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            jq
            gnumake
            alejandra
            nixUnstable
          ];
        };
      }
    );
}
