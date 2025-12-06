{ self, inputs, ... }:
let
  mkHost =
    {
      user ? "",
      host ? "",
      state ? "26.05",
      locale ? "zh_CN.UTF-8",
      timezone ? "Asia/Shanghai",
      nixpkgs ? inputs.nixpkgs,
      extraModules ? [ ],
    }:
    let
      myvars = {
        inherit
          user
          host
          state
          locale
          timezone
          ;
      };
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self myvars;
      };
      modules = [
        {
          networking.hostName = myvars.host;
          i18n.defaultLocale = myvars.locale;
          time.timeZone = myvars.timezone;
          system.stateVersion = myvars.state;
        }
      ]
      # and more modules
      ++ extraModules;
    };
in
{
  flake.nixosConfigurations = {
    yoga = mkHost {
      user = "iab";
      host = "yoga";
      extraModules = [
        ./yoga/configuration.nix
      ];
    };

    svp = mkHost {
      user = "zendo";
      host = "svp";
      # nixpkgs = inputs.nixpkgs-stable;
      extraModules = [
        ./svp/configuration.nix
      ];
    };

    rmt = mkHost {
      user = "aaa";
      host = "rmt";
      extraModules = [
        ./rmt/configuration.nix
      ];
    };

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

    # nix build .#nixosConfigurations.livecd-standard.config.system.build.isoImage
    livecd-standard = mkHost {
      user = "live";
      host = "livecd";
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
