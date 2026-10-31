{ config, inputs, ... }:
let
  inherit (config.flake) nixosConfigurations;
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
          path = nixosConfigurations."svp".pkgs.deploy-rs.lib.activate.nixos nixosConfigurations."svp";
        };
      };

      "rmt" = {
        hostname = "rmt";
        profiles.system = {
          path = nixosConfigurations."rmt".pkgs.deploy-rs.lib.activate.nixos nixosConfigurations."rmt";
        };
      };
    };
  };

  perSystem =
    { inputs', pkgs, ... }:
    {
      # nix flake show
      # nix build .#checks.x86_64-linux.deploy-schema
      checks = pkgs.deploy-rs.lib.deployChecks config.flake.deploy;

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
