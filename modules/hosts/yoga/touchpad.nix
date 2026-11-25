# 触摸板 06CB:CE44 的固件会自己从多点触控模式退回传统鼠标模式：只发 REL_X/REL_Y，
# hid-multitouch 建出来的 Touchpad 节点一条 ABS_MT_* 都没有，libinput 就把它当普通
# 鼠标，双指滚动/双指点击全失效，单指移动和按键照旧。
# 冷启动会退回，用一段时间（半小时左右）也会自己退回；退回时内核日志里没有任何 HID
# 事件，说明是固件行为，不是驱动重载。唯一恢复手段就是重载 hid-multitouch，
# 所以这里常驻一个监视器：触摸板的 "Mouse" 节点一旦开始上报 REL（正常的多点触控
# 模式下它一直是安静的），就重载模块。开机也先重载一次，省得第一条触摸是鼠标模式。

{
  flake.modules.nixos.host-yoga =
    {
      pkgs,
      ...
    }:
    let
      kmod = "${pkgs.kmod}/bin/modprobe";

      reload = ''
        ${kmod} -r hid-multitouch 2>/dev/null || true
        ${kmod} hid-multitouch 2>/dev/null || true
      '';

      watch = pkgs.writeScript "touchpad-watch.py" ''
        #!${pkgs.python3}/bin/python3
        # "Mouse" 节点只在这个固件退回鼠标模式时才有数据，所以它一出声就重载。
        import os, select, struct, subprocess, time

        NAME = "MSFT0001:00 06CB:CE44 Mouse"
        HID = "/sys/bus/hid/devices/0018:06CB:CE44.0003"
        MODPROBE = "${kmod}"


        def log(msg):
            print(f"touchpad-watch: {msg}", flush=True)


        def mouse_node():
            for ev in sorted(os.listdir("/sys/class/input")):
                if not ev.startswith("event"):
                    continue
                try:
                    with open(f"/sys/class/input/{ev}/device/name") as f:
                        if f.read().strip() == NAME:
                            return f"/dev/input/{ev}"
                except OSError:
                    continue
            return None


        def bound():
            try:
                return os.path.realpath(f"{HID}/driver").endswith("hid-multitouch")
            except OSError:
                return False


        last = 0.0
        while True:
            node = mouse_node()
            if node is None:
                time.sleep(2)
                continue
            try:
                fd = os.open(node, os.O_RDONLY | os.O_NONBLOCK)
            except OSError:
                time.sleep(2)
                continue
            log(f"watching {node}")
            try:
                while True:
                    if not select.select([fd], [], [], 5)[0]:
                        continue
                    try:
                        data = os.read(fd, 24 * 256)
                    except OSError:
                        # 节点被重载/设备重新枚举，回外层重新找。-ENODEV 不会返回空串，
                        # 只能靠异常判断，否则整个服务会以 status=1 掉一次。
                        log("节点失效，重新查找")
                        break
                    if not data:
                        break
                    if not any(
                        struct.unpack("H", data[i + 16 : i + 18])[0] == 2
                        for i in range(0, len(data) - 23, 24)
                    ):
                        continue
                    log("触摸板退回鼠标模式，重载 hid-multitouch")
                    # 防止极端情况下连着重载：两次之间至少隔 15 秒。
                    time.sleep(max(0.0, last + 15 - time.time()))
                    subprocess.run([MODPROBE, "-r", "hid-multitouch"], check=False)
                    subprocess.run([MODPROBE, "hid-multitouch"], check=False)
                    last = time.time()
                    log(f"重载完成，bound={bound()}")
                    time.sleep(2)
                    try:
                        while os.read(fd, 24 * 256):
                            pass
                    except OSError:
                        pass
                    break
            finally:
                os.close(fd)
            time.sleep(1)
      '';
    in
    {
      systemd.services.touchpad-watch = {
        description = "Reload hid-multitouch when the touchpad falls back to mouse mode";
        wantedBy = [ "graphical.target" ];
        # 开机那次重载会把节点号换掉，先让它跑完再开始监视。
        wants = [ "touchpad-reload-boot.service" ];
        after = [ "touchpad-reload-boot.service" ];
        serviceConfig = {
          ExecStart = watch;
          Restart = "always";
          RestartSec = 3;
        };
      };

      # 冷启动时固件就已经是鼠标模式了，等 udev 枚举完先重载一次。
      systemd.services.touchpad-reload-boot = {
        description = "Reload hid-multitouch at boot so the touchpad starts in touch mode";
        wants = [ "systemd-udev-settle.service" ];
        after = [
          "systemd-udevd.service"
          "systemd-udev-settle.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.writeShellScript "touchpad-reload" ''
            ${reload}
          ''}";
        };
      };
    };
}
