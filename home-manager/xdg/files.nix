{ config, pkgs, ... }:
let
  linkHome = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${path}";
  linkFlake =
    path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/${path}";
in
{
  home.file = {
    # ".memo".source = linkHome "Documents/memo";
  };

  xdg.configFile = {
    "cava".source = ../../dotfiles/cava;
    "shikane".source = ../../dotfiles/shikane;
    "swaylock".source = ../../dotfiles/swaylock;
    "alacritty".source = ../../dotfiles/alacritty;

    "mpv".source = linkFlake "dotfiles/mpv";
    "helix".source = linkFlake "dotfiles/helix";
    "waybar".source = linkFlake "dotfiles/waybar";
    "fuzzel".source = linkFlake "dotfiles/fuzzel";
    "yt-dlp".source = linkFlake "dotfiles/yt-dlp";
    "wezterm".source = linkFlake "dotfiles/wezterm";

    "niri".source = linkFlake "dotfiles/niri";
    "sway/config".source = linkFlake "dotfiles/sway/config";
    "hypr/hyprland.conf".source = linkFlake "dotfiles/hypr/hyprland.conf";
    "hypr/hypridle.conf".source = linkFlake "dotfiles/hypr/hypridle.conf";
    "hypr/hyprlock.conf".source = linkFlake "dotfiles/hypr/hyprlock.conf";

    "doom/config.org".source = linkFlake "dotfiles/org/doom-emacs.org";
    "emacs/all-emacs.org".source = linkFlake "dotfiles/org/all-emacs.org";

    # rime for ibus
    "ibus/rime/default.custom.yaml".source = ../../dotfiles/rime/default.custom.yaml;
    "ibus/rime/rime_ice.custom.yaml".source = ../../dotfiles/rime/rime_ice.custom.yaml;
    "ibus/rime/ibus_rime.custom.yaml".text = ''
      patch:
        style:
          horizontal: true
    '';
  };

  xdg.dataFile = {
    "goodvibes".source = ../../dotfiles/goodvibes;
    "color-schemes/Genshin.colors".source = ../../dotfiles/misc/kde-color-Genshin.colors;

    # rime for fcitx5
    "fcitx5/rime/default.custom.yaml".source = ../../dotfiles/rime/default.custom.yaml;
    "fcitx5/rime/rime_ice.custom.yaml".source = ../../dotfiles/rime/rime_ice.custom.yaml;

    # v2rayn
    # "v2rayN/bin/sing_box/sing-box".source = "${pkgs.sing-box}/bin/sing-box";
    # "v2rayN/bin/xray/xray".source = "${pkgs.xray}/bin/xray";
    # "v2rayN/bin/geoip.dat".source = "${pkgs.v2ray-geoip}/share/v2ray/geoip.dat";
    # "v2rayN/bin/geosite.dat".source = "${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat";
  };
}
