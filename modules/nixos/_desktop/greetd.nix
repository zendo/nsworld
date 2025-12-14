{
  lib,
  pkgs,
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    # useTextGreeter = true;
    settings = {
      default_session = {
        command = lib.concatStringsSep " " [
          "${lib.getExe pkgs.tuigreet}"
          "--time"
          "--asterisks"
          "--remember"
          "--remember-session"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        ];
      };
    };
  };
}
