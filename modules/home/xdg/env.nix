{ lib, config, ... }:
{
  home.sessionPath = [
    "${../../../dotfiles/bin}"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    # EDITOR = "emacsclient -c -a emacs";
    EDITOR = "micro";
    VISUAL = "micro";
    NIXOS_OZONE_WL = lib.mkDefault 1; # Electron wayland native
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
}
