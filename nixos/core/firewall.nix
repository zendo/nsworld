{ pkgs, ... }:
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

  environment.systemPackages = with pkgs; [
    firewalld-gui
  ];
}
