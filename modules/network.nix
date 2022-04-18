{
  config,
  pkgs,
  ...
}: {
  networking = {
    # hostName = "";
    useDHCP = false;
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    #interfaces.eno1.useDHCP = true;
    #interfaces.wlp1s0.useDHCP = true;

    nameservers = [
      "223.5.5.5"
      "223.6.6.6"
    ];

    # hosts = {
    #   "140.82.112.3" = [
    #     "gist.github.com"
    #     "github.com"
    #   ];
    #   "140.82.114.5" = ["api.github.com"];
    #   "185.199.108.133" = [
    #     "desktop.githubusercontent.com"
    #     "camo.githubusercontent.com"
    #     "github.map.fastly.net"
    #     "raw.githubusercontent.com"
    #     "user-images.githubusercontent.com"
    #     "favicons.githubusercontent.com"
    #     "avatars5.githubusercontent.com"
    #     "avatars4.githubusercontent.com"
    #     "avatars3.githubusercontent.com"
    #     "avatars2.githubusercontent.com"
    #     "avatars1.githubusercontent.com"
    #     "avatars0.githubusercontent.com"
    #     "avatars.githubusercontent.com"
    #     "media.githubusercontent.com"
    #   ];
    #   # proxy.default = "http://user:password@proxy:port/";
    #   # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  };

  # Proxy
  services.tor.tsocks.enable = true;
  services.tor.tsocks.server = "127.0.0.1:20170";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Publish this server and its address on the network
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      domain = true;
      addresses = true;
      workstation = true;
    };
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
