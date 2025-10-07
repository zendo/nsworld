{
  lib,
  nixosConfig,
  ...
}:
{
  imports =
    [
      ./ssh.nix
      ./git.nix
      ./cli.nix
      ./zsh.nix
      ./fish.nix
      ./bash.nix
      ./alias.nix
      ./files.nix
      ./nix-tools.nix
    ]
    # for desktop environment
    ++ lib.optionals nixosConfig.services.graphical-desktop.enable [
      ./gui.nix
      ./xdg.nix
      ./editor.nix
      ./nvim.nix
      ./chrome.nix
      ./firefox.nix
      ./ghostty.nix
    ]
    ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [ ./kderc.nix ]
    ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [ ./dconf.nix ];

  home = {
    enableNixpkgsReleaseCheck = false;
    stateVersion = nixosConfig.system.stateVersion;
  };
}
