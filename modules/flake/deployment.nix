/*
  nixos-rebuild --target-host root@192.168.1.197 \
    -S --flake .#svp switch
*/
{ inputs, lib, ... }:
{
  # =========================================================================
  # Colmena
  # https://github.com/juspay/colmena-flake/blob/main/flake-module.nix
  # https://git.eisfunke.com/MonsterDruide1/nixos/-/blob/main/flake/colmena.nix
  # =========================================================================
  flake.colmena =
    let
      deployment = {
        # colmena apply-local --sudo
        yoga = {
          targetHost = "yoga";
          targetUser = "iab";
          allowLocalDeployment = true;
        };
        # colmena apply --no-substitutes --on svp
        svp = {
          targetHost = "svp";
          targetUser = "root";
        };
        rmt = {
          targetHost = "rmt";
          targetUser = "root";
        };
      };
    in
    {
      meta = {
        nixpkgs = { inherit lib; };
        nodeNixpkgs = builtins.mapAttrs (name: value: value.pkgs) inputs.self.nixosConfigurations;
        nodeSpecialArgs = builtins.mapAttrs (
          name: value: value._module.specialArgs
        ) inputs.self.nixosConfigurations;
      };
    }
    // builtins.mapAttrs (name: value: {
      imports = value._module.args.modules;
      deployment = deployment.${name};
    }) inputs.self.nixosConfigurations;

  flake.colmenaHive = inputs.colmena.lib.makeHive inputs.self.outputs.colmena;

  # =========================================================================
  # deploy-rs
  # =========================================================================
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
    }; # end of nodes
  }; # end of flake.deploy
}
