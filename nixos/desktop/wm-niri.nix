{
  lib,
  pkgs,
  username,
  ...
}:
{
  # DisplayManager
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd niri";
      # Autologin
      # initial_session = {
      #   command = "niri";
      #   user = "${username}";
      # };
    };
  };

  # WIP!!!
  environment.systemPackages = with pkgs; [
    niri
  ];

  home-manager.users.${username} =
    {
    };
}
