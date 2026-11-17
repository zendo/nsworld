/*
  preseed 由 incus-preseed.service 在开机时套用,改完配置不用手动
  `incus admin init`;要立刻生效就 sudo systemctl restart incus-preseed。

  容器跑图形程序:
    incus profile add arch gui
  然后容器里直接跑 wayland 客户端即可(XDG_RUNTIME_DIR / WAYLAND_DISPLAY
  由 profile 的环境变量给出)。X11 老程序不起 Xwayland 也没别的地方可连,
  在容器里自起一个,复用同一个 wayland socket:
    Xwayland :0 -geometry 1280x800 & export DISPLAY=:0
*/
{
  flake.modules.nixos.incus =
    { ... }:
    {
      networking.firewall.trustedInterfaces = [
        "incusbr0"
      ];

      virtualisation.incus = {
        enable = true;
        ui.enable = true;

        preseed = {
          config = {
            # 只给远程 `incus remote add` 用。`incus webui` 不吃这个值,
            # 8443 也没在防火墙里放行,要远程管理时记得单独开。
            "core.https_address" = "[::]:8443";
          };
          networks = [
            {
              name = "incusbr0";
              type = "bridge";
              config = {
                "ipv4.address" = "10.0.100.1/24";
                "ipv4.nat" = true;
                "ipv6.address" = "none";
              };
            }
          ];
          storage_pools = [
            {
              name = "default";
              driver = "btrfs";
              config = {
                # btrfs 驱动下 source 留空会退化成 loop 文件,所以这行不能删:
                # 它指定的是 / 上的一个专用 subvolume。
                source = "/var/lib/incus/storage-pools/default";
              };
            }
          ];
          profiles = [
            # 给需要图形界面的实例用:`incus profile add <实例> gui`。
            # 全部走 proxy 设备(bind=instance),容器内自己看不到宿主机的
            # /run/user/1001,只能由 forkproxy 在两边各开一端桥起来。
            # 路径里的 1001 是宿主机 desktop 用户的 uid(`id -u iab`),
            # 这个 profile 只适合跑图形会话的那台机器;换机器要跟着改。
            {
              name = "gui";
              config = {
                # proxy 设备的 listen/connect 不展开环境变量(源码里直接
                # 调 net.Listen / net.Dial),路径只能写死,所以容器侧的
                # socket 名也固定,环境变量跟着钉死在这里。
                # 代价:XDG_RUNTIME_DIR 被改成 /run,容器里若再跑一套 systemd
                # 用户会话(pam_systemd 会给它设 /run/user/<uid>)就会互盖,
                # 那种场景把这行删掉、自己 export 到 socket 所在目录。
                "environment.XDG_RUNTIME_DIR" = "/run";
                "environment.WAYLAND_DISPLAY" = "wayland-0";
                "environment.PULSE_SERVER" = "unix:/run/pulse-native";
              };
              devices = {
                gpu = {
                  type = "gpu";
                };
                wayland = {
                  type = "proxy";
                  bind = "instance";
                  listen = "unix:/run/wayland-0";
                  connect = "unix:/run/user/1001/wayland-0";
                  # forkproxy 两端都以 root 跑(容器侧要 root 才能写 /run,
                  # 宿主机侧 root 不受 /run/user/1001 的 0700 限制),所以
                  # 不需要 security.uid/gid。只设 socket 属主和权限。
                  uid = "0";
                  gid = "0";
                  mode = "0660";
                };
                # PipeWire 的 pulse 兼容层,声音跟 GUI 是两回事,分开放便于单独摘。
                pulse = {
                  type = "proxy";
                  bind = "instance";
                  listen = "unix:/run/pulse-native";
                  connect = "unix:/run/user/1001/pulse/native";
                  uid = "0";
                  gid = "0";
                  mode = "0660";
                };
              };
            }
            {
              name = "default";
              devices = {
                eth0 = {
                  name = "eth0";
                  type = "nic";
                  network = "incusbr0";
                };
                root = {
                  path = "/";
                  pool = "default";
                  size = "25GiB";
                  # 跑 VM 时镜像文件在 btrfs 上反复覆写会撞 qgroup 配额,官方建议把
                  # size.state 设成 size 的两倍(容器不需要)。
                  # "size.state" = "50GiB";
                  type = "disk";
                };
              };
            }
          ];
        }; # end of preseed

      }; # end of virtualisation.incus
    };
}
