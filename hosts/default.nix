{ inputs, self, ... }:
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

    # nix build .#nixosConfigurations.livecd-standard.config.system.build.isoImage
    livecd-standard = mkHost {
      user = "live";
      host = "livecd";
      extraModules = [
        ./livecd/standard.nix
      ];
    };

    # nixos-rebuild build-image --image-variant iso-installer --flake .#livecd-minimal
    # nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage
    livecd-minimal = inputs.nixpkgs.lib.nixosSystem {
      modules = [ ./livecd/minimal.nix ];
    };
  };
}
