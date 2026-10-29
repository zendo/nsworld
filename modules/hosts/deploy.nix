{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (config.flake) nixosConfigurations;

  # https://github.com/serokell/deploy-rs#overall-usage
  deployLib =
    pkgs:
    (inputs.omniflake.flakes.deploy-rs.overlays.default (
      pkgs
      // {
        deploy-rs.deploy-rs = pkgs.deploy-rs;
      }
    ) pkgs).deploy-rs.lib;
in
{
  # ╭─────────────────────────────────────────────────────╮
  # │ Colmena                                             │
  # ╰─────────────────────────────────────────────────────╯
  flake.colmenaHive = inputs.omniflake.flakes.colmena.lib.makeHive {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ ];
      };
      # nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs) nixosConfigurations;
    };

    # colmena apply-local --sudo
    yoga = {
      imports = nixosConfigurations."yoga"._module.args.modules;
      deployment = {
        targetHost = "yoga";
        targetUser = "iab";
        allowLocalDeployment = true;
      };
    };

    # colmena apply --no-substitutes --on svp
    svp = {
      imports = nixosConfigurations."svp"._module.args.modules;
      deployment = {
        targetHost = "svp";
      };
    };

    rmt = {
      imports = nixosConfigurations."rmt"._module.args.modules;
      deployment = {
        targetHost = "rmt";
      };
    };
  };

  # ╭─────────────────────────────────────────────────────╮
  # │ deploy-rs                                           │
  # ╰─────────────────────────────────────────────────────╯
  flake.deploy = {
    sshUser = "root";
    autoRollback = false;
    magicRollback = false;
    fastConnection = true; # copy from ssh
    nodes = {
      # deploy -s --fast-connection true .#svp
      "svp" = {
        hostname = "svp";
        profiles.system = {
          path = (deployLib nixosConfigurations."svp".pkgs).activate.nixos nixosConfigurations."svp";
        };
      };

      "rmt" = {
        hostname = "rmt";
        profiles.system = {
          path = (deployLib nixosConfigurations."rmt".pkgs).activate.nixos nixosConfigurations."rmt";
        };
      };
    };
  };

  perSystem =
    { inputs', pkgs, ... }:
    {
      devshells.nsw-deploy = {
        packages = [
          pkgs.disko
          pkgs.nixos-anywhere
          pkgs.colmena
          pkgs.deploy-rs
          # inputs'.colmena.packages.colmena
          # inputs'.deploy-rs.packages.deploy-rs
          inputs'.nixpkgs.legacyPackages.nixos-rebuild-ng
        ];
      };
    };
}
