{ self, inputs, ... }:
{
  flake.nixosConfigurations =
    let
      mkHost =
        {
          hostname,
          username,
          nixpkgs ? inputs.nixpkgs,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            rootPath = ../.;
            inherit inputs self username;
          };
          modules = [
            # nixos setup
            {
              networking.hostName = "${hostname}";
            }
          ]
          # and more modules
          ++ extraModules;
        };
    in
    {
      yoga = mkHost {
        username = "iab";
        hostname = "yoga";
        extraModules = [
          ./yoga/configuration.nix
        ];
      };

      svp = mkHost {
        username = "zendo";
        hostname = "svp";
        # nixpkgs = inputs.nixpkgs-stable;
        extraModules = [
          ./svp/configuration.nix
        ];
      };

      rmt = mkHost {
        username = "aaa";
        hostname = "rmt";
        extraModules = [
          ./rmt/configuration.nix
        ];
      };

      # nix build .#nixosConfigurations.vmtest.config.system.build.vm
      vmtest = mkHost {
        username = "test";
        hostname = "vmtest";
        extraModules = [
          ./vmtest/configuration.nix
        ];
      };

      # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
      wsl = mkHost {
        username = "iab";
        hostname = "wsl";
        extraModules = [
          ./wsl/configuration.nix
        ];
      };

      # nix build .#nixosConfigurations.livecd-standard.config.system.build.isoImage
      livecd-standard = mkHost {
        username = "live";
        hostname = "livecd";
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
