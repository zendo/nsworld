{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    ### python ###
    python3
    pylyzer
    # ruff
    ### forntend ###
    # nodejs
    ### lsp ###
    bash-language-server
    typescript-language-server
    lua-language-server
    efm-langserver
    # nil
    nixd
    # devenv
    flamegraph
  ];
}
