{
  lib,
  inputs,
  config,
  nixosConfig,
  ...
}:
{
  # agenix
  # sudo cp /etc/ssh/ssh_host_ed25519_key  ~/.ssh/id_ed25519
  # sudo cp /etc/ssh/ssh_host_ed25519_key.pub ~/.ssh/id_ed25519.pub
  # sudo chown -R $USER  ~/.ssh
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

  # sops-nix
  # mkdir -p ~/.config/sops/age
  # sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt
  # chmod 600 ~/.config/sops/age/keys.txt
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ../secrets/sopsnix.nix
    inputs.agenix.homeManagerModules.default
    ../secrets/agenix.nix
    # -------------------------------------
    ./editor/helix.nix
    ./editor/micro.nix
    # -------------------------------------
    ./programs/cli.nix
    ./programs/git.nix
    ./programs/nix-tools.nix
    ./programs/ssh.nix
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
  ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [ ./wm/plasma.nix ]
  # ===========================================================
  # GNOME specific configurations
  # ===========================================================
  ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [ ./wm/dconf.nix ];

  # home.enableNixpkgsReleaseCheck = false;
  home.stateVersion = nixosConfig.system.stateVersion;
}
