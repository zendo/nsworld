{
  lib,
  pkgs,
  username,
  ...
}:
{
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

        # DEV
        nixd
        gcc
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
      (lib.hiPrio uutils-coreutils-noprefix)
      tree
      file
      wget
      micro
      dos2unix
      wslu
      wsl-open
      xdg-utils # for git oauth
    ];
  };

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = false;
  nixpkgs.hostPlatform = "x86_64-linux";

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

  # FIXME: https://github.com/microsoft/WSL/issues/12041
  # https://github.com/nix-community/NixOS-WSL/pull/648
  systemd.services."user-runtime-dir@" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      "" # unset old value
      "${pkgs.coreutils}/bin/true"
    ];
  };
}
