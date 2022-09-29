{
  config,
  pkgs,
  lib,
  ...
}: let
  mkOOSL = config.lib.file.mkOutOfStoreSymlink;
  hmHome = "${config.home.homeDirectory}/nsworld/dotfiles";
in
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "emacs -nw";
    EDITOR = "emacs -nw";
  };

  home.file = {
    ".doom.d".source = mkOOSL "${config.home.homeDirectory}/nsworld/emacs/doom";
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "kitty".source = ../dotfiles/kitty;
    "radioboat".source = ../dotfiles/radioboat;
    "foot/foot.ini".source = ../dotfiles/foot.ini;
    "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;

    # soft symbolic links
    "mako".source = mkOOSL hmHome + "/mako";
    "hypr".source = mkOOSL hmHome + "/hypr";
    "sway".source = mkOOSL hmHome + "/sway";
    "waybar".source = mkOOSL hmHome + "/waybar";
    "wayfire.ini".source = mkOOSL hmHome + "wayfire.ini";
  };
}
