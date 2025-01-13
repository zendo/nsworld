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
  };

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

  # vscode-remote-workaround
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

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = false;
}
