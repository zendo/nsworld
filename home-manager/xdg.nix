{ config, pkgs, lib, ... }:

let
  mkOOSL = config.lib.file.mkOutOfStoreSymlink;
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
    "nix-init".source = ../dotfiles/nix-init;

    "lf".source = mkOOSL hmDots + "/lf";
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
