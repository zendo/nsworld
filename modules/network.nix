{ config, pkgs, ... }:

{
  networking = {
    # hostName = "in flake";
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    #interfaces.eno1.useDHCP = true;
    #interfaces.wlp1s0.useDHCP = true;
    timeServers = [ "ntp.tuna.tsinghua.edu.cn" ];

    nameservers = [
      "223.5.5.5"
      "223.6.6.6"
    ];

    hosts = {
      "140.82.112.22" = [ "central.github.com" ];
      "140.82.112.25" = [ "live.github.com" ];
      "140.82.112.3" = [
        "gist.github.com"
        "github.com"
      ];
      "140.82.114.25" = [ "alive.github.com" ];
      "140.82.114.5" = [ "api.github.com" ];
      "140.82.114.9" = [ "codeload.github.com" ];
      "185.199.108.133" = [
        "desktop.githubusercontent.com"
        "camo.githubusercontent.com"
        "github.map.fastly.net"
        "raw.githubusercontent.com"
        "user-images.githubusercontent.com"
        "favicons.githubusercontent.com"
        "avatars5.githubusercontent.com"
        "avatars4.githubusercontent.com"
        "avatars3.githubusercontent.com"
        "avatars2.githubusercontent.com"
        "avatars1.githubusercontent.com"
        "avatars0.githubusercontent.com"
        "avatars.githubusercontent.com"
        "media.githubusercontent.com"
      ];
      "185.199.108.153" = [
        "assets-cdn.github.com"
        "github.io"
        "githubstatus.com"
      ];
      "185.199.108.154" = [ "github.githubassets.com" ];
      "192.0.66.2" = [ "github.blog" ];
      "199.232.69.194" = [ "github.global.ssl.fastly.net" ];
      "23.100.27.125" = [ "github.dev" ];
      "52.217.129.153" = [ "github-production-repository-file-5c1aeb.s3.amazonaws.com" ];
      "52.217.174.129" = [ "github-production-user-asset-6210df.s3.amazonaws.com" ];
      "52.217.199.41" = [ "github-com.s3.amazonaws.com" ];
      "52.217.223.17" = [ "github-cloud.s3.amazonaws.com" ];
      "52.217.93.164" = [ "github-production-release-asset-2e65be.s3.amazonaws.com" ];
      "64.71.144.202" = [ "github.community" ];};
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

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
