{ inputs, ... }:
let
  userName = "zendo";
in
{
  # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules =
      with inputs.self.modules.nixos;
      [
        host-wsl
        hmModule

        base
        fonts
        nixconfig
        nixpkgs
        ssh
        zsh
      ]
      ++ [
        inputs.nixos-wsl.nixosModules.wsl
      ];
  };

  flake.modules.nixos.host-wsl =
    { lib, pkgs, ... }:
    {
      # ╭─────────────────────────────────────────────────────╮
      # │  Home-manager                                       │
      # ╰─────────────────────────────────────────────────────╯
      home-manager.users.${userName} =
        { inputs, pkgs, ... }:
        {
          xdg.enable = true;

          home.packages = with pkgs; [
            # cliamp
            goodvibes
          ];

          imports = with inputs.self.modules.homeManager; [
            # [ common ]
            # secrets
            ssh
            nixconfig

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
            atuin
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
            # xdg
          ];
        };

      # ╭─────────────────────────────────────────────────────╮
      # │ System-wide                                         │
      # ╰─────────────────────────────────────────────────────╯
      environment = {
        sessionVariables = {
          BROWSER = "wsl-open";
        };

        systemPackages = with pkgs; [
          dos2unix
          wslu
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

      networking.hostName = "wsl";
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
