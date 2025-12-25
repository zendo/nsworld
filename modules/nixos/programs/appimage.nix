{ pkgs, config, ... }:
{
  programs.appimage = {
    enable = config.services.graphical-desktop.enable;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          libthai
          libsecret
          libepoxy
          # libdbusmenu-gtk3
          libappindicator-gtk3
          libsoup_3
          # webkitgtk_4_1
        ];
    };
  };
}
