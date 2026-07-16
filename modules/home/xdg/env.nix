{ inputs, ... }:
{
  flake.modules.homeManager.env =
    { lib, ... }:
    {
      home.sessionPath = [
        "${inputs.self}/dotfiles/bin"
      ];

      home.sessionVariables = {
        # EDITOR = "emacsclient -c -a emacs";
        EDITOR = "micro";
        VISUAL = "micro";
        PI_SKIP_VERSION_CHECK = "1";
        NIXOS_OZONE_WL = lib.mkDefault 1; # Electron wayland native
        _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
      };
    };
}
