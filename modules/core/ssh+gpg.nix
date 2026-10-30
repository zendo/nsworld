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
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
      hostKeys = [
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    programs.ssh.hosts = {
      yoga = {
        hostname = "192.168.2.218";
        order = 100;
      };

      svp = {
        hostname = "192.168.2.30";
        order = 200;
      };

      rmt = {
        hostname = "192.168.122.86";
        order = 300;
      };

      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        order = 400;
      };

      "*" = {
        serverAliveInterval = 60;
        serverAliveCountMax = 5;
        order = 1000;
      };
    };
  };

  flake.modules.nixos.gpg = {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
