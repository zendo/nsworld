{
  config,
  pkgs,
  ...
}: {
  /*
   sudo vi /etc/nix/nix.conf
   substituters = https://mirror.sjtu.edu.cn/nix-channels/store

   sudo vi /etc/nix/registry.json
   { "flakes":[], "version":2 }
   */

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

    # "nix/nix.conf".text = ''
    #   warn-dirty = false
    #   experimental-features = nix-command flakes
    # '';

    # "nix/registry.json".text = ''
    # { "flakes":[], "version":2 }
    # '';
  };
}
