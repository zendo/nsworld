# WIP...
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
    environment.sessionVariables = {
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
