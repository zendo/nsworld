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
      # systemd-resolved
      services.resolved = {
        enable = true;
      };

      networking = {
        # networkmanager.dns = "none"; # none/systemd-resolved
        # nameservers = [
        #   "223.5.5.5" # AliDNS
        #   "120.53.53.53" # DNSPod
        # ];

        # hosts = {
        #   "20.205.243.166" = ["github.com"];
        # };
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
