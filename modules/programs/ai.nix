/*
  pi install npm:@kkkiio/pi-web-ui
  ...
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
        pi-gpui
        pi-coding-agent
        # (pkgs.symlinkJoin {
        #   name = "pi-coding-agent";
        #   buildInputs = [ pkgs.makeWrapper ];
        #   paths = [ pkgs.pi-coding-agent ];
        #   postBuild = ''
        #         wrapProgram $out/bin/pi \
        #           --set NPM_CONFIG_PREFIX /home/${config.myVars.user}/.pi/agent/npm/ \
        #           --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nodejs ]}
        #     #   '';
        # })
      ];
    };
}
