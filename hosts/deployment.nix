/*
  # Deployment
  nixos-rebuild --target-host root@192.168.1.197 \
    --ask-sudo-password \
    --flake .#svp switch
*/
{ inputs, ... }:
{
  ###############################################
  ## deploy-rs
  ###############################################
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
  }; # end of flake.deploy

  ###############################################
  ## Colmena
  ###############################################
  imports = [ ./colmena-flake.nix ];

  colmena-flake.deployment = {
    # colmena apply-local --sudo -v
    yoga = {
      targetHost = "yoga";
      targetUser = "root";
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
}
