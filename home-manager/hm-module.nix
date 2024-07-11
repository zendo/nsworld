{ lib, nixosConfig, ... }:
{
  imports =
    [
      ./git.nix
      ./cli.nix
      ./zsh.nix
      ./bash.nix
      ./tmux.nix
      ./alias.nix
      ./files.nix
    ]
    # for desktop environment
    ++ lib.optionals nixosConfig.services.pipewire.enable [
      ./gui.nix
      ./xdg.nix
      ./editor.nix
      ./browsers.nix
      ./mods/polkit.nix
    ]
    ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [ ./kderc.nix ]
    ++ lib.optionals nixosConfig.services.xserver.desktopManager.gnome.enable [ ./dconf.nix ];

  home.stateVersion = nixosConfig.system.stateVersion;
  home.enableNixpkgsReleaseCheck = false;
}
