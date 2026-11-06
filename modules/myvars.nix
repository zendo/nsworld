/*
  端口分配规则: 4 C XX
    4    固定前缀。这台机器上的自建服务统一落在 4000-4399:
         > 1024 不用 root 也能绑;< 32768 不会撞内核的 ephemeral 端口段
         (net.ipv4.ip_local_port_range 默认 32768-60999),出站连接抢不走;
         也避开 3000/5000/8000/8080/9090 这些各框架的默认值。
    C    类别:  0 媒体阅读 / 1 文件传输 / 2 信息订阅 / 3 运维面板
    XX   类别内序号,01 起。新服务顺延;删掉的服务不要复用号码,
         否则旧书签、旧客户端配置、旧反代规则会静默指到错的服务上。

  例外(不参与本表):
    80 / 443       Caddy,唯一对外入口
    6881-6889      aria2 的 BT / DHT 对等端口
    6890           rqbit 的 BT 对等端口
                   BT 端口要跟着客户端与 tracker 的习惯走(6881 是公认默认),
                   而且必须对外入站,所以不套上面的规则。
*/
{
  flake.modules.nixos.myvars =
    { lib, config, ... }:
    {
      options.myVars = {
        user = lib.mkOption { type = lib.types.str; };
        ip = lib.mkOption { type = lib.types.attrsOf lib.types.str; };
        ports = lib.mkOption { type = lib.types.attrsOf lib.types.port; };
      };

      config.myVars = {
        ip = {
          yoga = "192.168.2.218";
          svp = "192.168.2.30";
          rmt = "192.168.122.86";
        };

        # ssh -N -L 4201:localhost:4202 user@ip
        # Now browser: http://localhost:4202
        ports = {
          # 40xx 媒体 / 阅读
          navidrome = 4001;
          kavita = 4002;
          suwayomi = 4003;
          comigo = 4004;
          immich = 4005;

          # 41xx 文件 / 下载
          webdav = 4101;
          goshs = 4102;
          dufs = 4103;
          aria2 = 4104; # JSON-RPC
          rqbit = 4105;

          # 42xx 信息 / 订阅
          memos = 4201;
          miniflux = 4202;
          sub-store = 4203;

          # 43xx 运维 / 面板
          dynacat = 4301;
          homepage = 4302;
          scrutiny = 4303; # 硬盘 SMART
          vaultwarden = 4304;
          beszel = 4309; # hub
        };
      };
    };
}
