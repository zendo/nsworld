# WIP...
/*
    https://github.com/nix-community/home-manager/tree/master/modules/misc/xdg
    .config/user-dirs.conf
    enabled=False

  .config/user-dirs.dirs
  XDG_DESKTOP_DIR="/home/uuu/Desktop"
  XDG_DOCUMENTS_DIR="/home/uuu/Documents"
  XDG_DOWNLOAD_DIR="/home/uuu/Downloads"
  XDG_MUSIC_DIR="/home/uuu/Music"
  XDG_PICTURES_DIR="/home/uuu/Pictures"
  XDG_PROJECTS_DIR="/home/uuu/Projects"
  XDG_PUBLICSHARE_DIR="/home/uuu/Public"
  XDG_TEMPLATES_DIR="/home/uuu/Templates"
  XDG_VIDEOS_DIR="/home/uuu/Videos"
*/
{ inputs, config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.hjemModule =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [ inputs.omniflake.flakes.hjem.nixosModules.default ];

      hjem.extraModules = with fm.hjem; [
        foo
        env
        # mime
      ];

      hjem.users.alice = {
        directory = "/home/alice";
        files = {
          ".config/foo".text = "bar";
          ".config/bar".source = pkgs.writeTextFile "file-foo" "file contents";
          ".config/baz" = {
            # 'generator' works with `pkgs.formats` too!
            generator = lib.generators.toJSON { };
            value = {
              some = "contents";
            };
          };
        };
      };

    };

  flake.modules.hjem.foo = { pkgs, ... }: {
    packages = with pkgs; [
      dippi
    ];
  };

  flake.modules.hjem.env = {
    environment.sessionVaruuules = {
      # EDITOR = "emacsclient -c -a emacs";
      EDITOR = "micro";
      VISUAL = "micro";
      PAGER = "moor";
      TERMINAL = "ghostty";
      PI_SKIP_VERSION_CHECK = "1";
      NIXOS_OZONE_WL = 1; # Electron wayland native
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };
  };

  # flake.modules.hjem.mime = {
  #   xdg.mime-apps.default-applications = { };
  # };
}
