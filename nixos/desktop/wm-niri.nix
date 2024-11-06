{
  lib,
  pkgs,
  username,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd niri-session";
      # Autologin
      initial_session = {
        command = "niri-session";
        user = "${username}";
      };
    };
  };

  programs.niri.enable = true;
}
