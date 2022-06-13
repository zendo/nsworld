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
    ".proxychains/proxychains.conf".source = ../dotfiles/proxychains.conf;

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
