{ config, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Host github.com
      #   HostName ssh.github.com
      #   Port 443

      Host yoga
        HostName 192.168.2.118
        Port 22
        User iab

      Host svp
        HostName 192.168.2.197
        Port 22
        User zendo

      Host rmt
        HostName 192.168.122.85
        Port 22
        User aaa

      #ProxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p
    '';
  };
}
