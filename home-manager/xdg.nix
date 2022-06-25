{
  config,
  pkgs,
  lib,
  nixosConfig,
  ...
}: let
  gnomeEnable = nixosConfig.services.xserver.desktopManager.gnome.enable;
in {
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "emacs -nw";
    EDITOR = "emacs -nw";
  };

  home.file = {
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;

    # fix tiny cursor in qt apps at gnome
    ".icons/default/index.theme".text = lib.optionalString gnomeEnable ''
      [icon theme]
      Inherits=Adwaita
    '';

    # ".local/share/fcitx5/themes".source = pkgs.fetchFromGitHub {
    #   owner = "icy-thought";
    #   repo = "fcitx5-catppuccin";
    #   rev = "3b699870fb2806404e305fe34a3d2541d8ed5ef5";
    #   sha256 = "hOAcjgj6jDWtCGMs4Gd49sAAOsovGXm++TKU3NhZt8w=";
    # };
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "helix".source = ../dotfiles/helix;
    "foot/foot.ini".source = ../dotfiles/foot.ini;
    "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;

    "autostart/qv2ray.desktop".text = ''
      [Desktop Entry]
      Name=qv2ray
      GenericName=V2Ray Frontend
      Exec=bash -c "sleep 5; qv2ray"
      Terminal=false
      Icon=qv2ray
      Categories=Network
      Type=Application
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';
  };

  # xdg.desktopEntries.spotify = lib.mkIf gnomeEnable {
  #   name = "Spotify";
  #   genericName = "Music Player";
  #   icon = "spotify-client";
  #   exec = "spotify %U --force-device-scale-factor=2";
  #   terminal = false;
  #   categories = ["Application" "Music"];
  # };
}
