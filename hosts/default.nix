{ inputs, self, ... }:
let
  mkHost =
    {
      user ? "",
      host ? "",
      nixpkgs ? inputs.nixpkgs,
      extraModules ? [ ],
    }:
    let
      myvars = {
        inherit
          user
          host
          ;
      };
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self myvars;
      };
      modules = [
        (
          { lib, ... }:
          {
            networking.hostName = myvars.host;
            i18n.defaultLocale = lib.mkDefault "zh_CN.UTF-8";
            time.timeZone = lib.mkDefault "Asia/Shanghai";
            system.stateVersion = lib.mkDefault "26.05";
          }
        )
      ]
      ++ extraModules;
    };
in
{
  flake.nixosConfigurations = {
    # nixos-rebuild --sudo --flake .#yoga switch
    yoga = mkHost {
      user = "iab";
      host = "yoga";
      extraModules = [
        ./yoga/configuration.nix
      ];
    };

    # nix build .#nixosConfigurations.svp.config.system.build.toplevel
    # ./result/bin/switch-to-configuration switch
    svp = mkHost {
      user = "zendo";
      host = "svp";
      # nixpkgs = inputs.nixpkgs-stable;
      extraModules = [
        ./svp/configuration.nix
      ];
    };

    # nixos-rebuild --target-host aaa@rmt -S --flake .#rmt switch
    rmt = mkHost {
      user = "aaa";
      host = "rmt";
      extraModules = [
        ./rmt/configuration.nix
      ];
    };

    # nixos-rebuild build-vm --flake .#vmtest
    # nix build .#nixosConfigurations.vmtest.config.system.build.vm
    vmtest = mkHost {
      user = "test";
      host = "vmtest";
      extraModules = [
        ./vmtest/configuration.nix
      ];
    };

    # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
    wsl = mkHost {
      user = "iab";
      host = "wsl";
      extraModules = [
        ./wsl/configuration.nix
      ];
    };

    # nixos-rebuild build-image --image-variant iso-installer --flake .#livecd
    # nix build .#nixosConfigurations.livecd.config.system.build.isoImage
    livecd = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
      };
      modules = [ ./livecd/configuration.nix ];
    };
  };
}
