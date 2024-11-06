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
      default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd sway";
      # Autologin
      initial_session = {
        command = "sway";
        user = "${username}";
      };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swayr
      autotiling-rs
    ];
  };
}
