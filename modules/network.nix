{
  config,
  pkgs,
  ...
}: {
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
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

    extraHosts = ''
      # GitHub520 Host Start
      140.82.112.25                 alive.github.com
      140.82.114.25                 live.github.com
      185.199.108.154               github.githubassets.com
      140.82.113.21                 central.github.com
      185.199.108.133               desktop.githubusercontent.com
      185.199.108.153               assets-cdn.github.com
      185.199.108.133               camo.githubusercontent.com
      185.199.108.133               github.map.fastly.net
      199.232.69.194                github.global.ssl.fastly.net
      140.82.113.3                  gist.github.com
      185.199.108.153               github.io
      140.82.113.4                  github.com
      192.0.66.2                    github.blog
      140.82.113.5                  api.github.com
      185.199.108.133               raw.githubusercontent.com
      185.199.108.133               user-images.githubusercontent.com
      185.199.108.133               favicons.githubusercontent.com
      185.199.108.133               avatars5.githubusercontent.com
      185.199.108.133               avatars4.githubusercontent.com
      185.199.108.133               avatars3.githubusercontent.com
      185.199.108.133               avatars2.githubusercontent.com
      185.199.108.133               avatars1.githubusercontent.com
      185.199.108.133               avatars0.githubusercontent.com
      185.199.108.133               avatars.githubusercontent.com
      140.82.114.9                  codeload.github.com
      52.217.107.156                github-cloud.s3.amazonaws.com
      52.216.100.147                github-com.s3.amazonaws.com
      52.217.105.68                 github-production-release-asset-2e65be.s3.amazonaws.com
      52.217.0.220                  github-production-user-asset-6210df.s3.amazonaws.com
      52.216.241.132                github-production-repository-file-5c1aeb.s3.amazonaws.com
      185.199.108.153               githubstatus.com
      64.71.144.211                 github.community
      23.100.27.125                 github.dev
      140.82.114.22                 collector.github.com
      13.107.42.16                  pipelines.actions.githubusercontent.com
      185.199.108.133               media.githubusercontent.com
      185.199.108.133               cloud.githubusercontent.com
      185.199.108.133               objects.githubusercontent.com


      # Update time: 2022-05-12T10:40:58+08:00
      # Update url: https://raw.hellogithub.com/hosts
      # Star me: https://github.com/521xueweihan/GitHub520
      # GitHub520 Host End

    '';
  };

  # Proxy
  services.tor.tsocks = {
    enable = true;
    server = "127.0.0.1:20170";
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
