{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # [ ide ]
        # zed-editor

        # [ base ]
        gcc
        cmake
        gnumake

        # [ python ]
        python3
        pylyzer
        # ruff
        # uv

        # [ forntend ]
        # nodejs

        # [ lsp ]
        bash-language-server
        typescript-language-server
        lua-language-server
        efm-langserver
        # nil
        nixd
        # devenv
        flamegraph
      ];
    };
}
