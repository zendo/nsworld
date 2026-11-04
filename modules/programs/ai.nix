{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    {
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
