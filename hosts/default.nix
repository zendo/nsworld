{ self, inputs, ... }:
{
  flake.nixosConfigurations =
    let
      mkHost =
        {
          myvars ? {
            user = "";
            host = "";
          },
          nixpkgs ? inputs.nixpkgs,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs self myvars;
          };
          modules = [
            (
              { lib, myvars, ... }:
              {
                networking.hostName = myvars.host;
                i18n.defaultLocale = lib.mkDefault "zh_CN.UTF-8";
                time.timeZone = lib.mkDefault "Asia/Shanghai";
                system.stateVersion = lib.mkDefault "26.05";
              }
            )
          ]
          # and more modules
          ++ extraModules;
        };
    in
    {
      yoga = mkHost {
        myvars = {
          user = "iab";
          host = "yoga";
        };
        extraModules = [
          ./yoga/configuration.nix
        ];
      };

      svp = mkHost {
        myvars = {
          user = "zendo";
          host = "svp";
        };
        # nixpkgs = inputs.nixpkgs-stable;
        extraModules = [
          ./svp/configuration.nix
        ];
      };

      rmt = mkHost {
        myvars = {
          user = "aaa";
          host = "rmt";
        };
        extraModules = [
          ./rmt/configuration.nix
        ];
      };

      # nix build .#nixosConfigurations.vmtest.config.system.build.vm
      vmtest = mkHost {
        myvars = {
          user = "test";
          host = "vmtest";
        };
        extraModules = [
          ./vmtest/configuration.nix
        ];
      };

      # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
      wsl = mkHost {
        myvars = {
          user = "iab";
          host = "wsl";
        };
        extraModules = [
          ./wsl/configuration.nix
        ];
      };

      # nix build .#nixosConfigurations.livecd-standard.config.system.build.isoImage
      livecd-standard = mkHost {
        myvars = {
          user = "live";
          host = "livecd";
        };
        extraModules = [
          ./livecd/standard.nix
        ];
      };

      # nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage
      livecd-minimal = inputs.nixpkgs.lib.nixosSystem {
        modules = [ ./livecd/minimal.nix ];
      };
    };
}
