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
        host-wsl-hjem

        myvars
        # secrets
        programs
        # services
        # selfhosted

        base
        fonts
        nixconfig
        nixpkgs
        nix-tools
        ssh

        # [ programs ]
        cli
        dev
        git

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
  # │  Hjem                                               │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.nixos.host-wsl-hjem = {
    imports = [ inputs.omniflake.flakes.hjem.nixosModules.default ];

    hjem = {
      clobberByDefault = true;

      users.${userName} = {
        directory = "/home/${userName}";
        imports = [ fm.hjem.links ];
      };
    };

    # WSL 里 wsl.exe 不经过 logind,没有登录会话就没有 /run/user/$UID,
    # hjem-reload@ 会打印 "Could not determine XDG runtime directory" 并 skip(exit 0)。
    # linger 让 systemd --user 开机即启动,RuntimePath 存在,reload 和 systemctl --user 才能用。
    users.users.${userName}.linger = true;
  };

  # ╭─────────────────────────────────────────────────────╮
  # │ System-wide                                         │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.nixos.host-wsl =
    { lib, pkgs, ... }:
    let
      sp = inputs.self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment = {
        systemPackages = with pkgs; [
          sp.wrapper-cava
          sp.wrapper-foot
          sp.wrapper-ghostty
          sp.wrapper-emacs

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
      i18n.defaultLocale = "zh_CN.UTF-8";

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
