{
  flake.modules.nixos.greetd =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        useTextGreeter = true;
        settings = {
          default_session = {
            command = ''
              ${lib.getExe pkgs.tuigreet} \
              --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions \
              --time \
              --time-format '%Y-%m-%d %H:%M' \
              --asterisks \
              --remember \
              --remember-session
            '';
          };
        };
      };
    };
}
