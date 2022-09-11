{
  config,
  pkgs,
  ...
}: {
  networking = {
    networkmanager.enable = true; # conflict with networking.wireless
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    #interfaces.eno1.useDHCP = true;
    #interfaces.wlp1s0.useDHCP = true;

    # proxy.default = "http://127.0.0.1:20171";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    nameservers = [
      "223.5.5.5"
      "223.6.6.6"
    ];
  };

  # Proxy
  services.tor.tsocks = {
    enable = true;
    server = "127.0.0.1:20170";
  };

  # systemd.services.nix-daemon.environment = {
  #   http_proxy = "http://127.0.0.1:20171";
  #   https_proxy = "http://127.0.0.1:20171";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Publish this server and its address on the network
  services.avahi = {
    enable = true;
    nssmdns = true;
    #   publish = {
    #     enable = true;
    #     domain = true;
    #     addresses = true;
    #     workstation = true;
    #   };
  };

  # Open ports for avahi zeroconf
  # networking.firewall.allowedUDPPorts = [ 5353 ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # OpenSnitch
  # services.opensnitch.enable = true;
}
