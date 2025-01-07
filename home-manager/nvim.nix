{ inputs, ... }:
{
  home.packages = [
    inputs.nvf.packages.x86_64-linux.default
    # inputs.nvf.packages.x86_64-linux.maximal
  ];

  # imports = [inputs.nvf.homeManagerModules.default];

  # https://github.com/NotAShelf/nvf/blob/main/configuration.nix
  # programs.nvf = {
  #   enable = true;
  #   settings.vim = {
  #     viAlias = false;
  #     vimAlias = true;
  #   };
  # };
}
