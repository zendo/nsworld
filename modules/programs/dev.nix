{
  flake.modules.nixos.dev =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # [ ide ]
        # zed-editor
        # gram # zed fork without ai
        # vscode

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

        # [ docker ]
        # lazydocker
        # docker-compose
        podman-compose
        compose2nix # compose2nix -project=my
        # pods
        # distrobox create -i archlinux
        distrobox
        # toolbox create -i quay.io/toolbx/arch-toolbox  / ubuntu-toolbox
        # toolbox

        # [ lsp ]
        bash-language-server
        # typescript-language-server
        lua-language-server
        efm-langserver
        # nil
        nixd
        # devenv
        flamegraph
      ];
    };
}
