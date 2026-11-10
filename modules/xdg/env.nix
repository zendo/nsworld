{
  flake.modules.nixos.env = {
    environment.localBinInPath = true; # ~/.local/bin
    environment.sessionVariables = {
      # EDITOR = "emacsclient -c -a emacs";
      EDITOR = "fresh";
      VISUAL = "fresh";
      # PAGER = "moor";
      TERMINAL = "ghostty";
      PI_SKIP_VERSION_CHECK = "1";
      NIXOS_OZONE_WL = 1; # Electron wayland native
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
  };
}
