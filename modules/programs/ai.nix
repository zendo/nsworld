/*
  pi install npm:@keywaytech/pi-provider-manager
  pi install npm:@kkkiio/pi-web-ui
*/
{
  flake.modules.nixos.ai =
    { pkgs, config, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs
        # paseo
        # t3code
        # opencode
        # codex
        # qwen-code
        # gemini-cli
        # claude-code
        # omp
        # pilo
        # pi-gpui
        pi-coding-agent
      ];

      # http://127.0.0.1:31415
      systemd.user.services.pi-ui = {
        description = "pi-ui";
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.pi-ui}/bin/pi-ui";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
}
