/*
  # Deployment
  deploy -s .#svp
  or
  nixos-rebuild --target-host zendo@192.168.2.198 --use-remote-sudo --flake .#svp boot
*/
{ inputs, self, ... }:
{
  flake.deploy = {
    sudo = "doas -u";
    autoRollback = false;
    magicRollback = false;
    fastConnection = true; # copy from ssh
    nodes = {
      "svp" = {
        hostname = "192.168.2.197";
        profiles.system = {
          user = "root";
          sshUser = "zendo";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."svp";
        };
      };

      "rmt" = {
        hostname = "192.168.122.85";
        profiles.system = {
          user = "root";
          sshUser = "aaa";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations."rmt";
        };
      };
    };
  };
}
