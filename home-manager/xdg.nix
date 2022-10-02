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
    "${config.home.homeDirectory}/.emacs.d/bin"
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
    # "eww".source = mkOOSL hmDots + "/eww";
    "mako".source = mkOOSL hmDots + "/mako";
    "hypr".source = mkOOSL hmDots + "/hypr";
    "waybar".source = mkOOSL hmDots + "/waybar";
    "wayfire.ini".source = mkOOSL hmDots + "/wayfire.ini";

    # Rime for ibus
    "ibus/rime/ibus_rime.yaml".source = ../dotfiles/rime/ibus_rime.yaml;
    "ibus/rime/default.custom.yaml".source = ../dotfiles/rime/default.custom.yaml;
    "ibus/rime/luna_pinyin_simp.custom.yaml".source = ../dotfiles/rime/luna_pinyin_simp.custom.yaml;
    "ibus/rime/luna_pinyin_simp.extended.dict.yaml".source = ../dotfiles/rime/luna_pinyin_simp.extended.dict.yaml;
  };

  xdg.dataFile = {
    # Rime for fcitx
    "fcitx5/rime/default.custom.yaml".source = ../dotfiles/rime/default.custom.yaml;
    "fcitx5/rime/luna_pinyin_simp.custom.yaml".source = ../dotfiles/rime/luna_pinyin_simp.custom.yaml;
    "fcitx5/rime/luna_pinyin_simp.extended.dict.yaml".source = ../dotfiles/rime/luna_pinyin_simp.extended.dict.yaml;
  };
}
