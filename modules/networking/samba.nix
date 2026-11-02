{
  flake.modules.nixos.samba =
    { config, pkgs, ... }:
    let
      # shared / media 两个共享只差一个路径,抽出来免得以后改了其中一个忘了另一个。
      # 注意:这些值都是字符串,和 smb.conf 里的写法一致("yes"/"no"/"0660"),
      # 写 true/false 也能被 nixpkgs 接受,但和 samba 文档对不上,容易看错。
      share =
        dir:
        {
          path = dir;

          # 下面 browseable / guest ok 其实都是 Samba 默认值,写出来只为表意
          browseable = "yes";
          "guest ok" = "no"; # 不做匿名共享(配合全局 map to guest = never)

          "read only" = "no"; # 可写。只想给客户端读的话改成 "yes"
          "valid users" = config.myVars.user; # 只有这个 smb 用户能进
          "force group" = "users"; # 落盘属组统一成 users,别的服务(users 组成员)才能读写
          "create mask" = "0660"; # 新文件 rw-rw----
          "directory mask" = "0770"; # 新目录 rwxrwx---
        };
    in
    {
      # https://wiki.nixos.org/wiki/Samba
      # 建 smb 账号(只存 samba 自己的密码库,和系统密码无关):
      #   sudo smbpasswd -a $(id -un)
      services.samba = {
        enable = true;
        # package = pkgs.samba4Full;

        # 会在整个 LAN 上放行 137,138/udp + 139,445/tcp。
        # 现代客户端(Windows 10+/macOS/Linux smbclient)其实只需要 445;
        # 想只开 445 就设 openFirewall = false,再自己写
        #   networking.firewall.allowedTCPPorts = [ 445 ];
        openFirewall = true;

        settings = {
          global = {
            # 这三条都是 Samba 默认值,写出来只是把意图钉住
            "server role" = "standalone server";
            "security" = "user";
            "map to guest" = "never"; # 认证失败直接拒绝,不降级成 guest

            # 这条是真起作用的:关掉 SMB1(WannaCry 那一代),
            # 代价是 Windows XP / 很老的电视盒子连不上。上限仍是默认的 SMB3。
            "server min protocol" = "SMB2_10";

            # Windows 10+ 的"网络"邻居里要看到这台机器,需要额外的 wsdd
            # (services.samba-wsdd,本机没开);直接敲 \\192.168.2.30 不受影响。
            # 想让客户端上显示的名字好看点,可以加:
            # "server string" = "svp (%h)";
          };

          # /data/shared 由 modules/xdg/data-center.nix 用 tmpfiles 建成 2770 + setgid,
          # /data/media 是 navidrome / kavita 的库目录
          shared = share "/data/shared";
          media = share "/data/media";
        };
      };
    };
}
