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
      # initial_session = {
      #   command = "niri-session";
      #   user = "${username}";
      # };
    };
  };

  xdg.portal.configPackages = [ pkgs.niri ];

  home-manager.users.${username} = {
    home.packages = with pkgs; [
      niri
    ];
  };
}
