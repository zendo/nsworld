{ config, lib, pkgs, ... }:

let
  mkOOSL = config.lib.file.mkOutOfStoreSymlink;
  hmDots = config.home.homeDirectory + "/nsworld/dotfiles";
in
{
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "micro";
    EDITOR = "micro";
  };

  home.file = {
    ".doom.d".source = mkOOSL hmDots + "/doom";
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "foot".source = ../dotfiles/foot;
    "helix".source = ../dotfiles/helix;
    "wezterm".source = ../dotfiles/wezterm;
    "gtklock".source = ../dotfiles/gtklock;
    "swaylock".source = ../dotfiles/swaylock;
    "nix-init".source = ../dotfiles/nix-init;
    "alacritty".source = ../dotfiles/alacritty;
    "radioboat".source = ../dotfiles/radioboat;
    "starship.toml".source = ../dotfiles/starship.toml;

    "emacs/init.el".source = ../dotfiles/emacs/init.el;
    "emacs/early-init.el".source = ../dotfiles/emacs/early-init.el;
    "emacs/elisp".source = mkOOSL hmDots + "/emacs/elisp";

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
