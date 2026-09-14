{
  flake.modules.nixos.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs
        pi-acp
        pi-coding-agent
        # opencode
        # codex
        # qwen-code
        # gemini-cli
        # claude-code
      ];
    };
}
