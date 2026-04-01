{ inputs, self, ... }:
let
  userName = "zendo";
in
{
  # sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      inputs.nixos-wsl.nixosModules.wsl
      self.modules.nixos.host-wsl
      self.modules.nixos.hmModule

      self.modules.nixos.base
      self.modules.nixos.fonts
      self.modules.nixos.nixconfig
      self.modules.nixos.nixpkgs
      self.modules.nixos.ssh
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
          imports = with inputs.self.modules.homeManager; [
            cli-imports

            foot
            ghostty
            # kitty
            dev
            emacs
          ];

          home.packages = with pkgs; [
            # cliamp
            goodvibes
          ];

          xdg.enable = true;
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
