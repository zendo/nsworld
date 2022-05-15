# https://github.com/fersilva16/nix-config
{inputs}: let
  inherit (inputs) nixpkgs home-manager;
in
  {
    hostname,
    system ? "x86_64-linux",
    username ? "unknow",
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs system hostname username;
      };

      modules = [
        home-manager.nixosModule

        (../hosts + "/${hostname}/hardware-configuration.nix")

        {
          networking.hostName = hostname;

          nixpkgs = {
            config.allowUnfree = true;
            # config.allowBroken = true;
            # config.allowUnsupportedSystem = true;
            overlays = with inputs; [
              nur.overlay
              emacs-overlay.overlay
              (import ../overlays)
              (final: prev: {
                local = local.legacyPackages.${prev.system};
              })
            ];
          };

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
      ];
      # ++ nixpkgs.lib.forEach users (user: ../users + "/${user}.nix");
    }
