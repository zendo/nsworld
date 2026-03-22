{
  flake.modules.homeManager.nvim =
    { inputs, pkgs, ... }:
    {
      home.packages = with pkgs; [
        neovim
      ];
    };
}
