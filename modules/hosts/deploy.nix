{ inputs, lib, ... }:
let
  inherit (inputs.self) nixosConfigurations;
in
{
  # ╭─────────────────────────────────────────────────────╮
  # │ Colmena                                             │
  # ╰─────────────────────────────────────────────────────╯
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta = {
      nixpkgs = { inherit lib; };
      nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) nixosConfigurations;
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
        targetUser = "root";
      };
    };

    rmt = {
      imports = nixosConfigurations."rmt"._module.args.modules;
      deployment = {
        targetHost = "rmt";
        targetUser = "root";
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
      # deploy -s .#svp
      "svp" = {
        hostname = "svp";
        profiles.system = {
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations."svp";
        };
      };

      "rmt" = {
        hostname = "rmt";
        profiles.system = {
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations."rmt";
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
          inputs'.colmena.packages.colmena
          # inputs'.deploy-rs.packages.deploy-rs
          inputs'.nixpkgs.legacyPackages.nixos-rebuild-ng
        ];
      };
    };
}
