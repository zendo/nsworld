{
  lib,
  pkgs,
  config,
  ...
}:
{
  services = {
    # https://wiki.debian.org/thermald
    thermald.enable = true;

    # Conflicts with auto-cpufreq
    power-profiles-daemon.enable = !config.services.auto-cpufreq.enable;

    # https://github.com/AdnanHodzic/auto-cpufreq
    auto-cpufreq = {
      enable = true;
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

    logind.settings.Login = {
      HandleLidSwitch = "suspend-then-hibernate";
    };
  };

  # Go into hibernate after specific suspend time
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=90min
  '';
}
