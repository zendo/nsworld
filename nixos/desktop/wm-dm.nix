{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  wm =
    if config.programs.sway.enable then
      "sway"
    else if config.programs.hyprland.enable then
      "Hyprland"
    else if config.programs.niri.enable then
      "niri-session"
    else
      throw "No Window Manager enabled!";
in
{
  # greetd
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd ${wm}";
      # autologin
      initial_session = {
        command = "${wm}";
        user = "${username}";
      };
    };
  };
}
