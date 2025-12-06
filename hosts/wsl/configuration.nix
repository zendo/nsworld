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
    inputs.self.nixosModules.homeManagerInit
    (self + /nixos/core/base.nix)
    (self + /nixos/core/fonts-cn.nix)
    (self + /nixos/core/nixpkgs.nix)
    (self + /nixos/core/nixconfig.nix)
  ];

  # ╭──────────────────────────────────────────────────────────╮
  # │  Home-manager                                            │
  # ╰──────────────────────────────────────────────────────────╯
  home-manager.users.${myvars.user} =
    { pkgs, ... }:
    {
      imports = [
        (self + /home-manager/terminal/foot.nix)
        (self + /home-manager/terminal/ghostty.nix)
        # (self + /home-manager/terminal/kitty.nix)
        (self + /home-manager/editor/dev-tools.nix)
        (self + /home-manager/editor/emacs.nix)
      ];

      home.packages = with pkgs; [
        foot
        goodvibes
      ];
    };

  # ╭──────────────────────────────────────────────────────────╮
  # │ System-wide                                              │
  # ╰──────────────────────────────────────────────────────────╯
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

  nixpkgs.hostPlatform = "x86_64-linux";

  # ╭──────────────────────────────────────────────────────────╮
  # │ WSL Settings                                             │
  # ╰──────────────────────────────────────────────────────────╯
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
