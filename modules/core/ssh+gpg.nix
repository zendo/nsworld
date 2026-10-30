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
  };

  flake.modules.nixos.ssh-hosts =
    { lib, config, ... }:
    {
      # Overdesigned. Keep it as a template.
      options.myVars.ip = lib.mkOption { type = lib.types.attrsOf lib.types.str; };

      config.myVars.ip = {
        yoga = "192.168.2.218";
        svp = "192.168.2.30";
        rmt = "192.168.122.86";
      };

      config = {
        programs.ssh.hosts = {
          # main
          yoga = {
            order = 100;
            hostname = config.myVars.ip.yoga;
          };

          # server
          svp = {
            order = 200;
            hostname = config.myVars.ip.svp;
            forwardAgent = true;
          };

          # qemu
          rmt = {
            order = 300;
            hostname = config.myVars.ip.rmt;
            forwardAgent = true;
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
    };

  flake.modules.nixos.gpg = {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
