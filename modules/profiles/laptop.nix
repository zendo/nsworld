{
  flake.modules.nixos.laptop =
    { pkgs, config, ... }:
    {
      services = {
        # 固件更新服务
        # fwupd.enable = true;
        # 只服务 Intel 热管理，AMD 上的对应物是 amd_pstate + PPD
        # thermald.enable = true;

        # sudo scx_rusty --monitor 0.5
        # scx-loader = {
        #   enable = true;
        #   config.default_sched = "scx_lavd"; # 或 scx_bpfland
        # };

        # Conflicts with auto-cpufreq
        power-profiles-daemon.enable = !config.services.auto-cpufreq.enable;

        # https://github.com/AdnanHodzic/auto-cpufreq
        # auto-cpufreq = {
        #   enable = true;
        #   settings = {
        #     battery = {
        #       governor = "powersave";
        #       turbo = "never";
        #     };
        #     charger = {
        #       governor = "performance";
        #       turbo = "auto";
        #     };
        #   };
        # };

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
