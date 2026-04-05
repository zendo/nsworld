{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        neovim
      ];
    };
}
