{ self, inputs, ... }:
let
  mkHost =
    {
      myvars ? { },
      nixpkgs ? inputs.nixpkgs,
      extraModules ? [ ],
    }:
    let
      defaultVars = {
        user = "";
        host = "";
        state = "26.05";
        locale = "zh_CN.UTF-8";
        timezone = "Asia/Shanghai";
      };
      vars = defaultVars // myvars;
    in
    nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self myvars;
      };
      modules = [
        {
          networking.hostName = vars.host;
          i18n.defaultLocale = vars.locale;
          time.timeZone = vars.timezone;
          system.stateVersion = vars.state;
        }
      ]
      # and more modules
      ++ extraModules;
    };
in
{
  flake.nixosConfigurations = {
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
