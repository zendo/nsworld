{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (config.flake) nixosConfigurations;

  # https://github.com/ulic-youthlic/flakes/blob/dev/core/deploy.nix#L15
  # deploy-rs only exposes its lib through an overlay, and that overlay ignores
  # `prev` (it always builds deploy-rs from the input's own source). Compose it
  # with a second overlay that puts nixpkgs' deploy-rs back in place, so the lib
  # (i.e. the `activate-rs` script it generates) uses `nixpkgs#deploy-rs`
  # instead of building a second deploy-rs.
  # NOTE: `prev` of the 2nd overlay is the result of the 1st one, hence `pkgs`.
  deployLib =
    pkgs:
    (pkgs.extend (
      lib.composeExtensions inputs.omniflake.flakes.deploy-rs.overlays.default (
        _: prev: {
          deploy-rs = prev.deploy-rs // {
            deploy-rs = pkgs.deploy-rs;
          };
        }
      )
    )).deploy-rs.lib;
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
      # nix flake show
      # nix build .#checks.x86_64-linux.deploy-schema
      checks = (deployLib pkgs).deployChecks config.flake.deploy;

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
