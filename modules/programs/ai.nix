{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs

        # paseo
        # t3code

        # opencode
        # qwen-code
        # gemini-cli
        # claude-code
        # codex

        /*
          pi install npm:@keywaytech/pi-provider-manager
          pi install npm:@kkkiio/pi-web-ui
        */
        pi-coding-agent
        # pi-gpui
        # pilo
        # omp

        # llm-agents.dsh
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
