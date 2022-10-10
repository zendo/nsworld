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
    VISUAL = "emacs -nw";
    EDITOR = "emacs -nw";
  };

  home.file = {
    # ".emacs.d/init.el".source = ../emacs/init.el;
    # ".emacs.d/early-init.el".source = ../emacs/early-init.el;
    # ".emacs.d/elisp".source = mkOOSL hmDots + "/emacs/elisp";
    ".doom.d".source = mkOOSL hmDots + "/doom";
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "kitty".source = ../dotfiles/kitty;
    "helix".source = ../dotfiles/helix;
    "gtklock".source = ../dotfiles/gtklock;
    "swaylock".source = ../dotfiles/swaylock;
    "radioboat".source = ../dotfiles/radioboat;
    "foot/foot.ini".source = ../dotfiles/foot.ini;
    "starship.toml".source = ../dotfiles/starship.toml;
    "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;

    # Soft Symbolic Links
    "lf".source = mkOOSL hmDots + "/lf";
    # "eww".source = mkOOSL hmDots + "/eww";
    "mako".source = mkOOSL hmDots + "/mako";
    "waybar".source = mkOOSL hmDots + "/waybar";
    "wayfire.ini".source = mkOOSL hmDots + "/wayfire.ini";
    "sway/custom.conf".source = mkOOSL hmDots + "/sway/custom.conf";
    "hypr/custom.conf".source = mkOOSL hmDots + "/hypr/custom.conf";
  };

  # xdg.dataFile = {
  # };
}
