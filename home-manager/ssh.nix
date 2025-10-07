{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # default config
    matchBlocks."*" = {
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
    extraConfig = ''
      Host github.com
        HostName ssh.github.com
        Port 443

      Host yoga
        HostName 192.168.2.218
        Port 22
        User root

      Host svp
        HostName 192.168.2.30
        Port 22
        User root

      Host rmt
        HostName 192.168.122.25
        Port 22
        User root

      #ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
    '';
  };
}
