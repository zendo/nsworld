/*
  doggo google.com
  ping github.com
  resolvectl status
  resolvectl query google.com
*/
{
  flake.modules.nixos.dns =
    { lib, config, ... }:
    {
      networking = {
        # nameservers = [
        #   "223.5.5.5" # AliDNS
        #   "120.53.53.53" # DNSPod
        # ];

        # hosts = {
        #   "20.205.243.166" = ["github.com"];
        # };
      };

      # systemd-resolved
      services.resolved = {
        enable = true;
      };

      # Publish this server and its address on the network
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        # publish = {
        #   enable = true;
        #   domain = true;
        #   addresses = true;
        #   workstation = true;
        # };
      };
    };
}
