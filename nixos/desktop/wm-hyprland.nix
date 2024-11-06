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

  programs.hyprland = {
    enable = true;
  };

  programs.hyprlock.enable = true;

  # auto-enabled by hyprlock
  # services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    # hyprpaper # wallpaper
    hyprpicker
  ];
}
