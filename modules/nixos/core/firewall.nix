/*
  sudo firewall-cmd --zone=trusted --add-interface=tun0 --permanent
  sudo firewall-cmd --reload
  sudo firewall-cmd --list-all-zones
  sudo firewall-cmd --add-port=1234/tcp
  maybe sudo firewall-cmd --add-port=1234/udp
  sudo firewall-cmd --list-ports
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
      # enable = true;
      zones.trusted.interfaces = [ "tun0" ];
    };
  };
}
