{ lib, ... }:
{
  networking = {
    networkmanager = {
      enable = true; # conflict with networking.wireless
      dns = "none"; # for Transparent Proxy
      wifi.backend = "iwd"; # replace "wpa_supplicant"
      plugins = lib.mkForce [ ]; # openconnect include (webkitgtk)
    };
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    # interfaces.eno1.useDHCP = true;
    # interfaces.wlp1s0.useDHCP = true;

    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];

    firewall = {
      enable = false;
      # allowedUDPPorts = [ 53317 ];
      # allowedTCPPorts = [ 53317 ];
    };

    # ping github.com
    # hosts = {
    #   "20.205.243.166" = ["github.com"];
    # };
  };

  # systemd.services.NetworkManager-wait-online.enable = false;

  services = {
    openssh = {
      enable = true;
      # Forbid root login through SSH.
      settings.PermitRootLogin = "no";
    };

    # resolved.enable = true;
    # resolved.fallbackDns = config.networking.nameservers;

    # opensnitch.enable = true;

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Publish this server and its address on the network
    avahi = {
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
