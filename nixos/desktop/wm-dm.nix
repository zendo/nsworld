{
  pkgs,
  config,
  username,
  ...
}:
{
  # https://ryjelsum.me/homelab/greetd-session-choose/
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.displayManager.sessionData.desktops}/share/xsessions:${config.services.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
        user = "${username}";
      };
    };
  };
}
