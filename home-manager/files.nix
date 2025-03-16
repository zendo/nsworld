{ config, ... }:
let
  linkHome = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${path}";
  linkFlake =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/${path}";
in
{
  home.file = {
    # ".memo".source = linkHome "Documents/memo";
    ".sub/sb-template.json".source = linkFlake "dotfiles/Windows/sb-template.json";
  };

  xdg.configFile = {
    "cava".source = ../dotfiles/cava;
    "wofi".source = ../dotfiles/wofi;
    "foot".source = ../dotfiles/foot;
    "kitty".source = ../dotfiles/kitty;
    "zellij".source = ../dotfiles/zellij;
    "swaylock".source = ../dotfiles/swaylock;
    "alacritty".source = ../dotfiles/alacritty;

    "mpv".source = linkFlake "dotfiles/mpv";
    "mako".source = linkFlake "dotfiles/mako";
    "helix".source = linkFlake "dotfiles/helix";
    "waybar".source = linkFlake "dotfiles/waybar";
    "yt-dlp".source = linkFlake "dotfiles/yt-dlp";
    "ghostty".source = linkFlake "dotfiles/ghostty";
    "wezterm".source = linkFlake "dotfiles/wezterm";

    "niri".source = linkFlake "dotfiles/niri";
    "sway/config".source = linkFlake "dotfiles/sway/config";
    "hypr/hyprland.conf".source = linkFlake "dotfiles/hypr/hyprland.conf";
    "hypr/hyprlock.conf".source = linkFlake "dotfiles/hypr/hyprlock.conf";

    "doom/config.org".source = linkFlake "dotfiles/org/doom-emacs.org";
    "emacs/all-emacs.org".source = linkFlake "dotfiles/org/all-emacs.org";
  };

  xdg.dataFile = {
    "goodvibes".source = ../dotfiles/goodvibes;
    "color-schemes/Genshin.colors".source = ../dotfiles/misc/kde-color-Genshin.colors;
  };
}
