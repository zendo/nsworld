{
  lib,
  nixosConfig,
  ...
}:
{
  imports = [
    ./editor/helix.nix
    ./editor/micro.nix
    # -------------------------------------
    ./programs/cli.nix
    ./programs/git.nix
    ./programs/nix-tools.nix
    ./programs/ssh.nix
    # -------------------------------------
    ./xdg/files.nix
  ]
  # ===========================================================
  # Automatically import
  # ===========================================================
  ++ (lib.filesystem.listFilesRecursive ./shell)
  # ===========================================================
  # Graphical Desktop Environment Configurations
  # ===========================================================
  ++ lib.optionals nixosConfig.services.graphical-desktop.enable [
    ./editor/dev-tools.nix
    ./editor/emacs.nix
    ./editor/nvim.nix
    ./editor/vscode.nix
    ./editor/zed.nix
    # -------------------------------------
    ./programs/chrome.nix
    ./programs/firefox.nix
    ./programs/gui.nix
    ./programs/vicinae.nix
    # -------------------------------------
    # ./terminal/alacritty.nix
    ./terminal/foot.nix
    ./terminal/ghostty.nix
    ./terminal/kitty.nix
    # -------------------------------------
    ./xdg/env.nix
    ./xdg/mime.nix
    ./xdg/xdg.nix
  ]
  # ===========================================================
  # KDE Plasma specific configurations
  # ===========================================================
  ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [ ./xdg/plasma.nix ]
  # ===========================================================
  # GNOME specific configurations
  # ===========================================================
  ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [ ./xdg/dconf.nix ];

  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = nixosConfig.system.stateVersion;
}
