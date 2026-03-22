{
  lib,
  pkgs,
  self,
  inputs,
  myvars,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    self.modules.nixos.hm
    # nixos core module
    self.modules.nixos.base
    self.modules.nixos.fonts
    self.modules.nixos.nixconfig
    self.modules.nixos.nixpkgs
    self.modules.nixos.ssh
  ];

  # ╭─────────────────────────────────────────────────────╮
  # │  Home-manager                                       │
  # ╰─────────────────────────────────────────────────────╯
  home-manager.users.${myvars.user} =
    { inputs, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        foot
        ghostty
        # kitty
        dev
        emacs
      ];

      home.packages = with pkgs; [
        foot
        goodvibes
      ];

      xdg.enable = true;
    };

  # ╭─────────────────────────────────────────────────────╮
  # │ System-wide                                         │
  # ╰─────────────────────────────────────────────────────╯
  environment = {
    sessionVariables = {
      EDITOR = "micro";
      VISUAL = "micro";
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

  nixpkgs.hostPlatform = "x86_64-linux";

  # ╭─────────────────────────────────────────────────────╮
  # │ WSL Settings                                        │
  # ╰─────────────────────────────────────────────────────╯
  wsl = {
    enable = true;
    defaultUser = "${myvars.user}";
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
