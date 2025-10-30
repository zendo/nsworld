{
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.homeManagerInit
    inputs.nixos-wsl.nixosModules.wsl
    ../../nixos/fonts.nix
    ../../nixos/nixpkgs.nix
    ../../nixos/nixconfig.nix
  ];

  ###############################################
  ##  Home-manager
  ###############################################
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      imports = [
        ../../home-manager/ghostty.nix
      ];

      home.packages = with pkgs; [
        # GUI
        foot
        kitty
        goodvibes

        # DEV
        nixd
        gcc
        gnumake
        cmake
        python3
        nodejs
      ];

      programs.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
        extraPackages =
          epkgs: with epkgs; [
            jinx
            vterm
            emojify
            sqlite3
            # lsp-bridge
            # pdf-tools
            # telega
            treesit-grammars.with-all-grammars
          ];
        extraConfig = ''
          (display-time-mode 1)
          ;; toggle-input-method
          ;; cp ~/nsworld/dotfiles/rime/default.custom.yaml ~/.config/emacs/rime/
          ;; touch ~/.config/emacs/rime/default.yaml
          (setq rime-librime-root "${pkgs.librime}"
                rime-emacs-module-header-root "${pkgs.emacs-pgtk}/include"
                rime-share-data-dir "${pkgs.rime-ice}/share/rime-data")
        '';
      };
    };

  ###############################################
  ##  System-wide
  ###############################################
  environment = {
    sessionVariables = {
      BROWSER = "wsl-open";
    };

    systemPackages = with pkgs; [
      dos2unix
      wslu
      wsl-open
      xdg-utils # for git oauth
    ];
  };

  programs.zsh.enable = true;

  nix.settings.auto-optimise-store = false;

  nixpkgs.hostPlatform = "x86_64-linux";
  i18n.defaultLocale = "zh_CN.UTF-8";
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = lib.mkDefault false;

  ###############################################
  ##  WSL Settings
  ###############################################
  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
  };

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
}
