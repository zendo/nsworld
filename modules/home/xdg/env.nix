{ inputs, ... }:
let
  customVariables = {
    # EDITOR = "emacsclient -c -a emacs";
    EDITOR = "micro";
    VISUAL = "micro";
    PAGER = "moor";
    TERMINAL = "ghostty";
    PI_SKIP_VERSION_CHECK = "1";
    NIXOS_OZONE_WL = 1; # Electron wayland native
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
in
{
  flake.modules.nixos.env = {
    environment.localBinInPath = true;

    environment.sessionVariables = customVariables;
  };

  flake.modules.homeManager.env = {
    home.sessionPath = [
      "${inputs.self}/dotfiles/bin"
    ];

    home.sessionVariables = customVariables;
  };
}
