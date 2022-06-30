{
  config,
  pkgs,
  lib,
  ...
}: {
  home.shellAliases = {
    nix = "nix --option substituters " https://mirror.sjtu.edu.cn/nix-channels/store "";
  };

  home.file = {
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "foot/foot.ini".source = ../dotfiles/foot.ini;
    "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;

    "nix/nix.conf".text = ''
      warn-dirty = false
    '';
  };
}
