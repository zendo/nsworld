/*
  ssh-add ~/.ssh/id_ed25519
  ssh-add -l
  echo "$SSH_AUTH_SOCK"
  ssh -T git@ssh.github.com -p 443
*/
{
  flake.modules.nixos.ssh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
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

      # gcr-ssh-agent (GNOME) 本身就是 SSH agent,并且会预加载 ~/.ssh/*.pub;
      # nixpkgs 断言它和 startAgent 不能共存,所以只在没有 gcr 时自己起 agent。
      programs.ssh.startAgent = !config.services.gnome.gcr-ssh-agent.enable;

      # OpenSSH 的 ssh-agent 不预加载任何 key,不自动添加的话 forwardAgent
      # 转发出去的是空 agent,远端照样拿不到 key。这里的 key 没有 passphrase,
      # 所以登录时静默添加;主机上没有这个 key 时 (如 svp) 不能让 unit 失败,
      # 否则 Restart=on-failure 会反复重启。
      systemd.user.services.ssh-agent = lib.mkIf config.programs.ssh.startAgent {
        serviceConfig.ExecStartPost = "${pkgs.bash}/bin/bash -c 'SSH_AUTH_SOCK=%t/ssh-agent ${pkgs.openssh}/bin/ssh-add -q %h/.ssh/id_ed25519 || true'";
      };
    };

  flake.modules.nixos.ssh-hosts =
    { lib, config, ... }:
    {
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

        vm-test = {
          order = 350;
          hostname = "127.0.0.1";
          port = 2222;
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
    };
  };
}
