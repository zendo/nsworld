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
    (rootPath + "/nixos/core/base.nix")
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
        (rootPath + "/home-manager/terminal/foot.nix")
        (rootPath + "/home-manager/terminal/ghostty.nix")
        # (rootPath + "/home-manager/terminal/kitty.nix")
        (rootPath + "/home-manager/editor/dev-tools.nix")
        (rootPath + "/home-manager/editor/emacs.nix")
      ];

      home.packages = with pkgs; [
        foot
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
}
