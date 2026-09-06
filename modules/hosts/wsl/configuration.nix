{ inputs, config, ... }:
let
  userName = "zendo";
  hostName = "wsl";
  fm = config.flake.modules;
in
{
  # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with fm.nixos;
      [
        host-wsl
        host-wsl-hm

        base
        fonts
        nixconfig
        nixpkgs
        ssh
        # fish
        zsh
      ]
      ++ [
        inputs.omniflake.flakes.nixos-wsl.nixosModules.wsl
      ];
  };

  # ╭─────────────────────────────────────────────────────╮
  # │  Home-manager                                       │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.nixos.host-wsl-hm = { config, pkgs, ... }: {
    imports = [ fm.nixos.hmModule ];

    home-manager.users.${config.myVars.user} = {
      home.packages = with pkgs; [
        # cliamp
        goodvibes
      ];

      imports = with fm.homeManager; [
        # [ common ]
        secrets
        ssh

        # [ editor ]
        dev
        emacs
        micro
        fresh-editor
        helix
        # nvim

        # [ programs ]
        cli
        git
        nix-tools

        # [ shell ]
        alias
        # atuin
        bash
        # fish
        starship
        # zellij
        zsh

        # [ terminal ]
        # alacritty
        foot
        ghostty
        # kitty

        # [ xdg ]
        env
        files
        xdg
      ];
    };
  };

  # ╭─────────────────────────────────────────────────────╮
  # │ System-wide                                         │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.nixos.host-wsl =
    { lib, pkgs, ... }:
    {
      environment = {
        sessionVariables = {
          BROWSER = "wsl-open";
        };

        systemPackages = with pkgs; [
          dos2unix
          wsl-open
          xdg-utils # for git oauth
          wl-clipboard
        ];
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
