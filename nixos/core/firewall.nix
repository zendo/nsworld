/*
  sudo firewall-cmd --permanent --zone=trusted --add-interface=tun0
  sudo firewall-cmd --reload
  sudo firewall-cmd --list-all-zones
*/
{ ... }:
{
  networking = {
    nftables.enable = true;
    firewall = {
      enable = false;
      # allowedUDPPorts = [ 53317 ];
      # allowedTCPPorts = [ 53317 ];
    };
  };

  services = {
    firewalld = {
      enable = true;
    };
  };
}
