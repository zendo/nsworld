{ self, inputs, ... }:
{
  flake.nixosConfigurations =
    let
      mkHost =
        {
          hostname,
          username,
          nixpkgs ? inputs.nixpkgs,
          system ? "x86_64-linux",
          defaultModules ? true,
          hmEnable ? true,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs self username;
          };
          modules =
            [
              # nixos setup
              {
                networking.hostName = "${hostname}";
              }
              # disko module
              inputs.disko.nixosModules.disko
            ]
            ++ nixpkgs.lib.optionals hmEnable [
              # home-manager module
              inputs.home-manager.nixosModules.home-manager
              # home-manager initialize
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "hm_bak~";
                  extraSpecialArgs = {
                    inherit inputs;
                  };
                  sharedModules = [
                    ../home-manager/hm-module.nix
                  ];
                  # home-manager user initialize
                  users.${username}.home.username = username;
                };
              }
            ]
            # modules from ../nixos/flake-module
            ++ nixpkgs.lib.optionals defaultModules [ self.nixosModules.default ]
            # and more modules
            ++ extraModules;
        };
    in
    {
      # nixos-rebuild --use-remote-sudo --flake .#yoga
      yoga = mkHost {
        username = "iab";
        hostname = "yoga";
        extraModules = [
          ./yoga
          ./common/laptop.nix
        ];
      };

      # nixos-rebuild --target-host zendo@192.168.2.198 --use-remote-sudo --flake .#svp boot
      svp = mkHost {
        username = "zendo";
        hostname = "svp";
        # nixpkgs = inputs.nixpkgs-stable;
        extraModules = [
          ./svp
          ./common/laptop.nix
        ];
      };

      # remote machine test @ qemu
      rmt = mkHost {
        username = "aaa";
        hostname = "rmt";
        # hmEnable = false;
        extraModules = [ ./rmt ];
      };

      # nixos-rebuild build-vm --flake .#vmtest
      vmtest = mkHost {
        username = "test";
        hostname = "vmtest";
        # hmEnable = false;
        extraModules = [ ./vmtest ];
      };

      # nix build .#nixosConfigurations.livecd-graphical.config.system.build.isoImage
      livecd-graphical = mkHost {
        username = "live";
        hostname = "livecd";
        extraModules = [ ./livecd/graphical.nix ];
      };

      # nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage
      livecd-minimal = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        system = "x86_64-linux";
        modules = [ ./livecd/minimal.nix ];
      };

      # nix build .#nixosConfigurations.wsl.config.system.build.tarballBuilder
      wsl = mkHost {
        username = "iab";
        hostname = "wsl";
        defaultModules = false;
        extraModules = [
          ./wsl
          ../nixos/fonts.nix
          ../nixos/nixpkgs.nix
          ../nixos/nixconfig.nix
          inputs.nixos-wsl.nixosModules.wsl
        ];
      };
    };
}
