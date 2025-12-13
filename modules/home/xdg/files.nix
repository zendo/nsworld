{ config, ... }:
let
  staticDot = path: ../../../dotfiles/${path};
  linkDot =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/${path}";
in
{
  xdg.configFile = {
    "cava".source = staticDot "cava";

    "mpv".source = linkDot "mpv";
    "yt-dlp".source = linkDot "yt-dlp";
    "doom/config.org".source = linkDot "org/doom-emacs.org";
    "emacs/all-emacs.org".source = linkDot "org/all-emacs.org";

    "sway/config".source = linkDot "sway/config";
    "niri/configs".source = linkDot "niri/configs";
    "niri/config.kdl".source = linkDot "niri/config.kdl";
    "hypr/hyprland.conf".source = linkDot "hypr/hyprland.conf";
    "hypr/hypridle.conf".source = linkDot "hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = linkDot "hypr/hyprlock.conf";

    # rime for ibus
    "ibus/rime/default.custom.yaml".source = staticDot "rime/default.custom.yaml";
    "ibus/rime/rime_ice.custom.yaml".source = staticDot "rime/rime_ice.custom.yaml";
    "ibus/rime/ibus_rime.custom.yaml".text = ''
      patch:
        style:
          horizontal: true
    '';
  };

  xdg.dataFile = {
    "goodvibes".source = staticDot "goodvibes";
    "color-schemes/Genshin.colors".source = staticDot "misc/kde-color-Genshin.colors";

    # rime for fcitx5
    "fcitx5/rime/default.custom.yaml".source = staticDot "rime/default.custom.yaml";
    "fcitx5/rime/rime_ice.custom.yaml".source = staticDot "rime/rime_ice.custom.yaml";
  };
}
