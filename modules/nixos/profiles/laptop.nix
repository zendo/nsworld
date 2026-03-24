{
  flake.modules.nixos.laptop =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services = {
        # 监听电源事件响应
        acpid.enable = true;
        # 固件更新服务
        fwupd.enable = true;
        # Intel 热管理: https://wiki.debian.org/thermald
        thermald.enable = config.hardware.cpu.intel.updateMicrocode;

        # sudo scx_rusty --monitor 0.5
        scx = {
          # enable = true;
          scheduler = "scx_rusty";
          package = pkgs.scx.rustscheds;
        };

        # Conflicts with auto-cpufreq
        power-profiles-daemon.enable = !config.services.auto-cpufreq.enable;

        # https://github.com/AdnanHodzic/auto-cpufreq
        auto-cpufreq = {
          # enable = true;
          settings = {
            battery = {
              governor = "powersave";
              turbo = "never";
            };
            charger = {
              governor = "performance";
              turbo = "auto";
            };
          };
        };

        # logind.settings.Login = {
        #   HandleLidSwitch = "suspend-then-hibernate";
        # };
      };

      # Go into hibernate after specific suspend time
      # systemd.sleep.extraConfig = ''
      #   HibernateDelaySec=90min
      # '';
    };
}
