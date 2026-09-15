/*
  ssh-add ~/.ssh/id_ed25519
  ssh-add -l
  echo "$SSH_AUTH_SOCK"
  ssh -T git@ssh.github.com -p 443
*/
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      # settings.PasswordAuthentication = lib.mkDefault false;
      hostKeys = [
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    programs.ssh.extraConfig = ''
      Host rmt
        forwardAgent yes
        hostname 192.168.122.86
        port 22

      Host svp
        forwardAgent yes
        hostname 192.168.15.197
        port 22

      Host yoga
        hostname 192.168.15.118
        port 22

      Host github.com
        hostname ssh.github.com
        port 443
        # 很多机场禁用 22 端口，代理一样无法连接
        # proxyCommand nc -X 5 -x 127.0.0.1:7890 %h %p

      Host *
        serverAliveCountMax 5
        serverAliveInterval 60
    '';
  };

  flake.modules.nixos.gpg = {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
