/*
  # Deployment
  deploy -s .#svp
  or
  nixos-rebuild --target-host root@192.168.1.197 \
    --ask-sudo-password \
    --flake .#svp switch
*/
{ inputs, ... }:
{
  flake.deploy = {
    # sudo = "doas -u";
    sshUser = "root";
    autoRollback = false;
    magicRollback = false;
    fastConnection = true; # copy from ssh
    nodes = {
      "svp" = {
        hostname = "192.168.2.30";
        profiles.system = {
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."svp";
        };
      };

      "rmt" = {
        hostname = "192.168.122.25";
        profiles.system = {
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."rmt";
        };
      };
    };
  };
}
