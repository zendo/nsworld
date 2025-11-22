{
  lib,
  nixosConfig,
  ...
}:
{
  imports = [
    ./xdg/files.nix
    ./editor/micro.nix
    ./editor/helix.nix
    ./programs/ssh.nix
    ./programs/git.nix
    ./programs/cli.nix
    ./programs/nix-tools.nix
  ]
  ++ (lib.filesystem.listFilesRecursive ./shell)
  # for desktop environment
  ++ lib.optionals nixosConfig.services.graphical-desktop.enable [
    ./xdg/env.nix
    ./xdg/xdg.nix
    ./xdg/mime.nix
    # terminal
    ./terminal/foot.nix
    ./terminal/kitty.nix
    ./terminal/ghostty.nix
    # ./terminal/alacritty.nix
    # programs
    ./programs/gui.nix
    ./programs/chrome.nix
    ./programs/firefox.nix
    ./programs/vicinae.nix
    # dev & editor
    ./editor/nvim.nix
    ./editor/emacs.nix
    ./editor/vscode.nix
    ./editor/zed.nix
    ./editor/dev-tools.nix
  ]
  ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [ ./xdg/plasma.nix ]
  ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [ ./xdg/dconf.nix ];

  home.stateVersion = nixosConfig.system.stateVersion;
}
