{
  flake.modules.nixos.selfhosted =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # 只对系统级实例生效。用户级配置在 ~/.config/syncthing 里,由 UI 管,这几项选项它也不吃。
      config = lib.mkIf (config.services.syncthing.enable && config.services.syncthing.systemService) {
        services.syncthing = {
          # 用日常用户跑:同步下来的文件 owner 就是自己,
          user = config.myVars.user;
          group = "users";
          # dataDir 用 nixpkgs 默认的 /var/lib/syncthing(配置/索引/密钥在那),
          # 同步目录在 UI 里另选。

          # Web UI 只走 Caddy。同步协议端口由 openDefaultPorts 放行:
          # TCP/UDP 22000 + UDP 21027(LAN 内发现),否则只能走中继,慢到没法用。
          guiAddress = "127.0.0.1:${toString config.myVars.ports.syncthing}";
          openDefaultPorts = lib.mkDefault true;

          # 设备和目录都在 Web UI 里加。这两个选项默认是 true,
          # 会每次启动把 Nix 里没声明的设备/目录删掉,所以必须关掉。
          overrideDevices = lib.mkDefault false;
          overrideFolders = lib.mkDefault false;

          settings.gui = {
            user = "admin";
            # 反代后 Host 是 syncthing.home.arpa,默认的 Host 校验会直接 403
            insecureSkipHostcheck = true;
          };

          # GUI 默认没有密码(原本只监听 127.0.0.1),反代出去后必须给一个。
          guiPasswordFile = toString (pkgs.writeText "syncthing-gui-password" "123");
        };

        # user 不是默认的 syncthing 用户时模块不会建 dataDir,这里补上
        systemd.tmpfiles.settings."10-syncthing".${config.services.syncthing.dataDir}.d = {
          inherit (config.services.syncthing) user group;
          mode = "0700";
        };
      };
    };
}
