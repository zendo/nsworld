{ inputs, config, ... }:
let
  userName = "zendo";
  hostName = "wsl";
  fm = config.flake.modules;
in
{
  # ╭─────────────────────────────────────────────────────╮
  # │  nixosConfigurations                                │
  # ╰─────────────────────────────────────────────────────╯
  # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with fm.nixos;
      [
        host-wsl
        host-wsl-hm
        # host-wsl-hjem

        base
        fonts
        nixconfig
        nixpkgs
        nix-tools
        ssh
        emacs

        # [ programs ]
        cli
        dev

        # [ shell ]
        alias
        bash
        # fish
        zsh
        terminal
        env
      ]
      ++ [
        inputs.omniflake.flakes.nixos-wsl.nixosModules.wsl
      ];
  };

  # ╭─────────────────────────────────────────────────────╮
  # │  Home-manager                                       │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.nixos.host-wsl-hm = {
    imports = [ fm.nixos.hmModule ];

    home-manager.users.${userName} = {
      imports = with fm.homeManager; [
        secrets
        links
        xdg
      ];
    };
  };

  # ╭─────────────────────────────────────────────────────╮
  # │  Hjem                                               │
  # ╰─────────────────────────────────────────────────────╯
  # error: Could not determine XDG runtime directory XDG_RUNTIME_DIR
  flake.modules.nixos.host-wsl-hjem = {
    imports = [ inputs.omniflake.flakes.hjem.nixosModules.default ];

    hjem.users.${userName} = {
      directory = "/home/${userName}";
      clobberByDefault = true;
      imports = [ fm.hjem.links ];
    };
  };

  # ╭─────────────────────────────────────────────────────╮
  # │ System-wide                                         │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.nixos.host-wsl =
    { lib, pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
          wrapper-cava
          wrapper-foot
          wrapper-ghostty
          wrapper-git

          # [ WSL ]
          dos2unix
          wsl-open
          xdg-utils # for git oauth
          wl-clipboard
        ];

        sessionVariables = {
          BROWSER = "wsl-open";
        };
      };

      wsl = {
        enable = true;
        defaultUser = userName;
        startMenuLaunchers = true;
      };

      # users.defaultUserShell = pkgs.fish;

      networking.hostName = hostName;
      nixpkgs.hostPlatform = "x86_64-linux";

      # https://github.com/K900/vscode-remote-workaround
      systemd.user = {
        paths.vscode-remote-workaround = {
          wantedBy = [ "default.target" ];
          pathConfig.PathChanged = "%h/.vscode-server/bin";
        };
        services.vscode-remote-workaround.script = ''
          for i in ~/.vscode-server/bin/*; do
            echo "Fixing vscode-server in $i..."
            ln -sf ${lib.getExe pkgs.nodejs} $i/node
          done
        '';
      };
    };
}
