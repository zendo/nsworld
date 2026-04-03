{ inputs, lib, ... }:
{
  # ╭─────────────────────────────────────────────────────╮
  # │ Colmena                                             │
  # ╰─────────────────────────────────────────────────────╯
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta = {
      nixpkgs = { inherit lib; };
      nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) inputs.self.nixosConfigurations;
      nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs) inputs.self.nixosConfigurations;
    };

    # colmena apply-local --sudo
    yoga = {
      imports = inputs.self.nixosConfigurations.yoga._module.args.modules;
      deployment = {
        targetHost = "yoga";
        targetUser = "iab";
        allowLocalDeployment = true;
      };
    };

    # colmena apply --no-substitutes --on svp
    svp = {
      imports = inputs.self.nixosConfigurations.svp._module.args.modules;
      deployment = {
        targetHost = "svp";
        targetUser = "root";
      };
    };

    rmt = {
      imports = inputs.self.nixosConfigurations.rmt._module.args.modules;
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
    # sudo = "doas -u";
    sshUser = "root";
    autoRollback = false;
    magicRollback = false;
    fastConnection = true; # copy from ssh
    nodes = {
      # deploy -s .#svp
      "svp" = {
        hostname = "svp";
        profiles.system = {
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."svp";
        };
      };

      "rmt" = {
        hostname = "rmt";
        profiles.system = {
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."rmt";
        };
      };
    };
  };

}
