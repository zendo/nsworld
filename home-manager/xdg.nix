{
  config,
  pkgs,
  ...
}: {
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "emacs -nw";
    EDITOR = "emacs -nw";
  };

  home.file = {
    # ".local/share/fcitx5/themes".source = pkgs.fetchFromGitHub {
    #   owner = "icy-thought";
    #   repo = "fcitx5-catppuccin";
    #   rev = "3b699870fb2806404e305fe34a3d2541d8ed5ef5";
    #   sha256 = "hOAcjgj6jDWtCGMs4Gd49sAAOsovGXm++TKU3NhZt8w=";
    # };
  };

  xdg.configFile = {
    "mpv".source = ../dotfiles/mpv;
    "foot/foot.ini".source = ../dotfiles/foot.ini;
    "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
    "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;

    # https://github.com/NickCao/flakes/commit/e019b7e498d495d1b0cfa7bd7b26d0615647a9de
    "qv2ray/plugin_settings/builtin_v2ray_support.json".source = (pkgs.formats.json {}).generate "v2ray.json" {
      AssetsPath = "${pkgs.symlinkJoin {
        name = "assets";
        paths = [pkgs.v2ray-geoip pkgs.v2ray-domain-list-community];
      }}/share/v2ray";
      CorePath = "${pkgs.v2ray.core}/bin/v2ray";
    };

    "autostart/qv2ray.desktop".text = ''
      [Desktop Entry]
      Name=qv2ray
      GenericName=V2Ray Frontend
      Exec=bash -c "sleep 5; qv2ray"
      Terminal=false
      Icon=qv2ray
      Categories=Network
      Type=Application
      StartupNotify=false
      X-GNOME-Autostart-enabled=true
    '';
  };

  # ~/.inputrc
  programs.readline = {
    enable = true;
    bindings = {
      "\\C-h" = "backward-kill-word";
    };
    extraConfig = ''
      set bell-style none
      set completion-ignore-case on
      # Show all tab-completion options on first <tab>
      set show-all-if-ambiguous on
      $if Bash
          # In bash only, enable "magic space" so that typing space
          # will show completions. i.e. !!_ (where _ is space)
          # will expand !! for you.
          Space: magic-space
      $endif
    '';
  };
}
