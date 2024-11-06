{
  lib,
  pkgs,
  username,
  ...
}:
{
  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gcc
        cmake
        gnumake
        python3
        nixd
      ];

      programs.emacs = {
        enable = true;
        package = pkgs.emacs30-pgtk;
        extraPackages =
          epkgs: with epkgs; [
            jinx
            vterm
            emojify
            emacsql-sqlite
            # lsp-bridge
            # pdf-tools
            # telega
            (treesit-grammars.with-grammars (p: builtins.attrValues p))
          ];
        extraConfig = ''
          (display-time-mode 1)
        '';
      };
    };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    nix-bash-completions
    wslu
    wsl-open

    # GUI
    foot
    kitty
    # goodvibes
  ];

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  documentation = {
    enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.11";
}
