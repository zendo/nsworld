{
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
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
