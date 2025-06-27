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
            inherit inputs self username;
          };
          modules =
            [
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
      # nixos-rebuild --sudo --flake .#yoga switch
      yoga = mkHost {
        username = "iab";
        hostname = "yoga";
        extraModules = [
          ./yoga
        ];
      };

      # nixos-rebuild --target-host zendo@192.168.2.198 --sudo --flake .#svp boot
      svp = mkHost {
        username = "zendo";
        hostname = "svp";
        # nixpkgs = inputs.nixpkgs-stable;
        extraModules = [
          ./svp
        ];
      };

      # test machine
      rmt = mkHost {
        username = "aaa";
        hostname = "rmt";
        extraModules = [
          ./rmt
        ];
      };

      # nixos-rebuild build-vm --flake .#vmtest
      # or
      # nix build .#nixosConfigurations.vmtest.config.system.build.vm
      vmtest = mkHost {
        username = "test";
        hostname = "vmtest";
        extraModules = [
          ./vmtest
        ];
      };

      # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
      wsl = mkHost {
        username = "iab";
        hostname = "wsl";
        extraModules = [
          ./wsl
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
