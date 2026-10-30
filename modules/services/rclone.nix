{
  flake.modules.nixos.services =
    { lib, pkgs, ... }:
    {
      # http://127.0.0.1:35259/login?pass=demo&url=http://127.0.0.1:44529&user=demo
      systemd.user.services.rclone-gui = {
        enable = lib.mkDefault false;
        description = "Rclone Web GUI";
        after = [ "network.target" ];
        wants = [ "network.target" ];
        serviceConfig = {
          ExecStart = lib.escapeShellArgs [
            "${pkgs.rclone}/bin/rclone"
            "gui"
            "--addr"
            "127.0.0.1:35259"
            "--api-addr"
            "127.0.0.1:44529"
            "--user"
            "demo"
            "--pass"
            "demo"
            "--no-open-browser"
          ];
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
