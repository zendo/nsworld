{
  lib,
  nixosConfig,
  ...
}:
{
  imports = [
    ./misc/alias.nix
    ./misc/files.nix
    ./programs/ssh.nix
    ./programs/git.nix
    ./programs/cli.nix
    ./programs/nix-tools.nix
    ./editor/micro.nix
    ./editor/helix.nix
  ]
  ++ (lib.filesystem.listFilesRecursive ./shell)
  # for desktop environment
  ++ lib.optionals nixosConfig.services.graphical-desktop.enable [
    ./misc/xdg.nix
    ./programs/gui.nix
    ./programs/chrome.nix
    ./programs/firefox.nix
    ./programs/ghostty.nix
    ./programs/kitty.nix
    ./programs/vicinae.nix
    # dev & editor
    ./editor/nvim.nix
    ./editor/emacs.nix
    ./editor/vscode.nix
    ./editor/zed.nix
    ./editor/dev-tools.nix
  ]
  ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [ ./misc/plasma.nix ]
  ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [ ./misc/dconf.nix ];

  home.stateVersion = nixosConfig.system.stateVersion;
}
