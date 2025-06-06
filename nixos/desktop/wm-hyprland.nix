{
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;

  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    # hyprpaper # wallpaper
    hyprpicker
  ];
}
