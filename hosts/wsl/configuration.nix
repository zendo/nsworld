{
  lib,
  pkgs,
  inputs,
  username,
  rootPath,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    inputs.self.nixosModules.homeManagerInit
    (rootPath + "/nixos/core/fonts.nix")
    (rootPath + "/nixos/core/nixpkgs.nix")
    (rootPath + "/nixos/core/nixconfig.nix")
  ];

  ###############################################
  ##  Home-manager
  ###############################################
  home-manager.users.${username} =
    { pkgs, ... }:
    {
      imports = [
        (rootPath + "/home-manager/programs/ghostty.nix")
        (rootPath + "/home-manager/editor/dev-tools.nix")
        (rootPath + "/home-manager/editor/emacs.nix")
      ];

      home.packages = with pkgs; [
        # GUI
        foot
        kitty
        goodvibes
      ];
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
