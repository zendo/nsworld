# 触摸板 06CB:CE44 (Synaptics) 的固件会停在传统鼠标模式：只上报 REL_X/REL_Y，
# hid-multitouch 建出来的 Touchpad 节点一条 ABS_MT_* 都没有，libinput 只能当普通鼠标用，
# 于是双指滚动/双指点击全失效，单指移动和按键照旧。
# - 冷启动：hid-generic 先绑过一次，固件没被切到多点触控模式。
# - 睡眠唤醒：i2c_hid_acpi resume 报 -121 (EREMOTEIO)，设备根本就没重新初始化。
# 重载 hid-multitouch 会让驱动重发一次 input mode，固件就切回多点触控。
# sudo modprobe -r hid-multitouch && sudo modprobe hid-multitouch
{
  flake.modules.nixos.host-yoga =
    {
      pkgs,
      ...
    }:
    let
      reloadTouchpad = pkgs.writeShellScript "hid-multitouch-reload" ''
        dev=/sys/bus/hid/devices/0018:06CB:CE44.0003
        # 设备不在（别的机器）就直接成功退出，不留下 failed 状态。
        [ -e /sys/bus/i2c/devices/i2c-MSFT0001:00 ] || exit 0

        # 唤醒后 I2C 设备要过一两秒才应答，重试到真的绑上 hid-multitouch 为止。
        for _ in 1 2 3 4 5 6 7 8 9 10; do
          ${pkgs.kmod}/bin/modprobe -r hid-multitouch 2>/dev/null || true
          ${pkgs.kmod}/bin/modprobe hid-multitouch 2>/dev/null || true
          if [ "$(readlink -f "$dev/driver" 2>/dev/null)" = /sys/bus/hid/drivers/hid-multitouch ]; then
            exit 0
          fi
          sleep 1
        done
        echo "touchpad did not bind to hid-multitouch" >&2
        exit 1
      '';
    in
    {
      # 冷启动一次。
      systemd.services.hid-multitouch-reload = {
        description = "Reload hid-multitouch so the touchpad leaves mouse mode";
        # MT 节点是 udev 建的，等设备枚举完再插模块，否则重载可能落在设备出现之前。
        wants = [ "systemd-udev-settle.service" ];
        after = [
          "systemd-udevd.service"
          "systemd-udev-settle.service"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = reloadTouchpad;
        };
      };

      # 挂在 suspend.target 之后的单元是唤醒时才跑；不能设 RemainAfterExit，
      # 否则单元一直停在 active，下一次唤醒 systemd 就不会再触发它。
      systemd.services.hid-multitouch-reload-resume = {
        description = "Reload hid-multitouch after resume";
        wants = [ "systemd-udev-settle.service" ];
        after = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
        ];
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = reloadTouchpad;
        };
      };
    };
}
