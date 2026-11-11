{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    {
      environment.sessionVariables = {
        PI_SKIP_VERSION_CHECK = "1";
      };

      environment.systemPackages = with pkgs; [
        nodejs
        paseo
        # t3code
        # omp
        pi-coding-agent
        # opencode
        # codex
        # qwen-code
        # gemini-cli
        # claude-code
      ];
    };
}
