{
  lib,
  nixosConfig,
  inputs,
  ...
}:
{
  imports = [
    inputs.self.modules.homeManager.secrets
    inputs.self.modules.homeManager.ssh
    inputs.self.modules.homeManager.nixconfig

    ./editor/helix.nix
    ./editor/micro.nix
    # -------------------------------------
    ./programs/cli.nix
    ./programs/git.nix
    ./programs/nix-tools.nix
    # -------------------------------------
    ./shell/alias.nix
    ./shell/atuin.nix
    ./shell/bash.nix
    ./shell/fish.nix
    ./shell/starship.nix
    ./shell/zellij.nix
    ./shell/zsh.nix
    # -------------------------------------
    ./xdg/files.nix
  ]
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
    ./programs/cava.nix
    ./programs/chrome.nix
    ./programs/firefox.nix
    ./programs/gui.nix
    ./programs/rclone.nix
    ./programs/vicinae.nix
    # -------------------------------------
    # ./terminal/alacritty.nix
    ./terminal/foot.nix
    ./terminal/ghostty.nix
    # ./terminal/kitty.nix
    # -------------------------------------
    ./xdg/env.nix
    ./xdg/mime.nix
    ./xdg/xdg.nix
  ]
  # ===========================================================
  # KDE Plasma specific configurations
  # ===========================================================
  ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
    inputs.self.modules.homeManager.plasma-manager
  ]
  # ===========================================================
  # GNOME specific configurations
  # ===========================================================
  ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [
    inputs.self.modules.homeManager.dconf
  ];

  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = nixosConfig.system.stateVersion;
}
