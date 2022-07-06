/*

*/
{
  config,
  pkgs,
  ...
}: {
  # home.shellAliases = {
  # };

  home.file = {
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "foot/foot.ini".source = ../dotfiles/foot.ini;
    "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;

    "nix/nix.conf".source = ../dotfiles/nix/nix.conf;
    "nix/flake-registry.json".source = ../dotfiles/flake-registry.json;
  };
}
