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
    # nixos core module
    (self + /modules/nixos/core/base.nix)
    (self + /modules/nixos/core/fonts-cn.nix)
    (self + /modules/nixos/core/nixpkgs.nix)
    (self + /modules/nixos/core/nixconfig.nix)
    # nixos hm module
    (self + /modules/home/hm-as-module.nix)
  ];

  # ╭──────────────────────────────────────────────────────────╮
  # │  Home-manager                                            │
  # ╰──────────────────────────────────────────────────────────╯
  home-manager.users.${myvars.user} =
    { pkgs, ... }:
    {
      imports = [
        (self + /modules/home/terminal/foot.nix)
        (self + /modules/home/terminal/ghostty.nix)
        # (self + /modules/home/terminal/kitty.nix)
        (self + /modules/home/editor/dev-tools.nix)
        (self + /modules/home/editor/emacs.nix)
      ];

      home.packages = with pkgs; [
        foot
        goodvibes
      ];

      xdg.enable = true;
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
