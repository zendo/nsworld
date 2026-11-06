/*
  硬盘 S.M.A.R.T 监控。
    - scrutiny: web + sqlite,只绑 127.0.0.1,走 Caddy 反代;
    - scrutiny-collector: 每天 smartctl 采集一次,推给 web;
    - influxdb2: 存历史曲线(温度趋势图全在它这里,没它图表就是空白)。

  模块里不启用任何服务,host 侧一行:
      services.scrutiny.enable = true;

  influxdb2 是 scrutiny 模块隐式带起来的实例(services.scrutiny.influxdb.enable 默认 true),
  这里只在 scrutiny 启用后补上一次性初始化:org/bucket/token 手写固定,
  scrutiny 用同一个 token 读写,免得去数据库里翻。
  注意 initialSetup 只在 /var/lib/influxdb2/influxd.bolt 不存在时执行。
*/
{
  flake.modules.nixos.selfhosted =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      influxOrg = "scrutiny";
      influxBucket = "scrutiny";
      # 和真实 influx token 一样是 88 字符;token 太短 influx setup 会拒绝
      influxToken = "z4P+V1hdEsIWo5WedCVAkgmIp95t+Yarw8VolSxbmC8rPpnYTstkX6yBU7LW+tDLVPiz2gvak2UFzaVKlR4GIFjT";
    in
    {
      # 全部塞进 mkIf:没开 scrutiny 的机器上不会多出 influxdb2 的配置
      config = lib.mkIf config.services.scrutiny.enable {
        services.influxdb2 = {
          # 默认 ":8086" 对所有网卡开放,这里只留 loopback
          settings.http-bind-address = "127.0.0.1:8086";

          provision = {
            # 这里不是"启动服务",只是让 influxdb2 首次启动跑一次 influx setup;
            # 关掉的话库里没有 token,scrutiny 启动时会 panic
            enable = true;
            initialSetup = {
              organization = influxOrg;
              bucket = influxBucket;
              username = "admin";
              passwordFile = pkgs.writeText "influxdb2-admin-password" "scrutiny-123456";
              tokenFile = pkgs.writeText "influxdb2-admin-token" influxToken;
            };
          };
        };

        services.scrutiny = {
          settings = {
            web.listen = {
              host = "127.0.0.1";
              port = config.myVars.ports.scrutiny;
            };
            web.influxdb = {
              host = "127.0.0.1";
              port = 8086;
              org = influxOrg;
              bucket = influxBucket;
              token = influxToken;
            };
          };
          # collector.enable 默认跟随 scrutiny.enable;改采集频率在这里
          collector.settings.host.id = config.networking.hostName;
        };

      };
    };
}
