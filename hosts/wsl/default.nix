{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./vscode-remote-workaround.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
  };

  vscode-remote-workaround.enable = true;

  home-manager.users.${username} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # GUI
        foot
        kitty
        ghostty
      ];

      imports = [
        ../../home-manager/emacs.nix
      ];
    };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    wslu
    wsl-open
  ];

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # nixos-rebuild-ng: Python-based re-implementation
  system.rebuild.enableNg = true;

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = false;
}
