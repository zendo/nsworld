{ config, pkgs, ... }:
let
  linkHome = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${path}";
  linkDot =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/${path}";
  staticDot = path: ../../../dotfiles/${path};
in
{
  home.file = {
    # ".memo".source = linkHome "Documents/memo";
  };

  xdg.configFile = {
    "cava".source = staticDot "cava";
    "shikane".source = staticDot "shikane";

    "mpv".source = linkDot "mpv";
    "helix".source = linkDot "helix";
    "fuzzel".source = linkDot "fuzzel";
    "yt-dlp".source = linkDot "yt-dlp";
    "swaylock".source = linkDot "swaylock";

    "sway/config".source = linkDot "sway/config";
    "niri/configs".source = linkDot "niri/configs";
    "niri/config.kdl".source = linkDot "niri/config.kdl";
    "hypr/hyprland.conf".source = linkDot "hypr/hyprland.conf";
    "hypr/hypridle.conf".source = linkDot "hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = linkDot "hypr/hyprlock.conf";

    "doom/config.org".source = linkDot "org/doom-emacs.org";
    "emacs/all-emacs.org".source = linkDot "org/all-emacs.org";

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

    # v2rayn
    # "v2rayN/bin/sing_box/sing-box".source = "${pkgs.sing-box}/bin/sing-box";
    # "v2rayN/bin/xray/xray".source = "${pkgs.xray}/bin/xray";
    # "v2rayN/bin/geoip.dat".source = "${pkgs.v2ray-geoip}/share/v2ray/geoip.dat";
    # "v2rayN/bin/geosite.dat".source = "${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat";
  };
}
