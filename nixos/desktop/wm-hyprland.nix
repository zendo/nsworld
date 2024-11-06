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
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
      # Autologin
      initial_session = {
        command = "Hyprland";
        user = "${username}";
      };
    };
  };

  home-manager.users.${username} = {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        source=./custom.conf
      '';
    };

    home.packages = with pkgs; [
      # hyprpaper # wallpaper
      hyprpicker
      hyprlock
    ];
  };
}
