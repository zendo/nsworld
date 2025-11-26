{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      # default config from:
      # https://github.com/nix-community/home-manager/blob/master/modules/programs/ssh.nix#L648
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        # 很多机场禁用 22 端口，代理一样无法连接
        # proxyCommand = "nc -X 5 -x 127.0.0.1:7890 %h %p";
      };
      yoga = {
        hostname = "192.168.2.218";
        port = 22;
      };
      svp = {
        hostname = "192.168.2.30";
        port = 22;
      };
      rmt = {
        hostname = "192.168.122.247";
        port = 22;
      };
    };
    extraConfig = ''
      Host example1
        HostName 192.168.122.247
        Port 22
        User root
    '';
  };
}
