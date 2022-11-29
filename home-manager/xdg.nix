{
  config,
  pkgs,
  lib,
  ...
}: let
  mkOOSL = config.lib.file.mkOutOfStoreSymlink;
  hmHome = config.home.homeDirectory;
  hmDots = config.home.homeDirectory + "/nsworld/dotfiles";
in
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.xdg.configHome}/emacs/bin"
  ];

  home.sessionVariables = {
    VISUAL = "micro";
    EDITOR = "micro";
  };

  home.file = {
    # ".emacs.d/init.el".source = ../emacs/init.el;
    # ".emacs.d/early-init.el".source = ../emacs/early-init.el;
    # ".emacs.d/elisp".source = mkOOSL hmDots + "/emacs/elisp";
    ".doom.d".source = mkOOSL hmDots + "/doom";
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;

    # ".local/share/fcitx5/themes".source = pkgs.fetchurl {
    #   url = "https://github.com/scratch-er/fcitx5-breeze/releases/download/v2.0.0/fcitx5-breeze-prebuilt-2.0.0.tar.gz";
    #   sha256 = "0wwwvq90dcb21avdgcqq5w192ndr2m5fmswxblm3l2vcrh36h3jz";
    # };
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "foot".source = ../dotfiles/foot;
    "kitty".source = ../dotfiles/kitty;
    "helix".source = ../dotfiles/helix;
    "wezterm".source = ../dotfiles/wezterm;
    "gtklock".source = ../dotfiles/gtklock;
    "swaylock".source = ../dotfiles/swaylock;
    "alacritty".source = ../dotfiles/alacritty;
    "starship.toml".source = ../dotfiles/starship.toml;
    "radioboat".source = ../dotfiles/radioboat;

    "lf".source = mkOOSL hmDots + "/lf";
    # "eww".source = mkOOSL hmDots + "/eww";
    "mako".source = mkOOSL hmDots + "/mako";
    "waybar".source = mkOOSL hmDots + "/waybar";
    "wayfire.ini".source = mkOOSL hmDots + "/wayfire.ini";
    "sway/custom.conf".source = mkOOSL hmDots + "/sway/custom.conf";
    "hypr/custom.conf".source = mkOOSL hmDots + "/hypr/custom.conf";
  };

  xdg.dataFile = {
    "goodvibes".source = ../dotfiles/goodvibes;
    "color-schemes/Genshin.colors".source = ../dotfiles/misc/kde-color-Genshin.colors;
  };
}
