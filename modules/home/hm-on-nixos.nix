{
  flake.modules.homeManager.hm-on-nixos =
    {
      lib,
      nixosConfig,
      inputs,
      ...
    }:
    {
      imports =
        with inputs.self.modules.homeManager;
        [
          secrets
          ssh
          nixconfig

          helix
          micro

          cli
          git
          nix-tools

          alias
          atuin
          bash
          fish
          starship
          # zellij
          zsh

          files
        ]
        # =================================================
        # Graphical Desktop Environment Configurations
        # =================================================
        ++ lib.optionals nixosConfig.services.graphical-desktop.enable [
          dev
          emacs
          nvim
          vscode
          zed

          cava
          chrome
          firefox
          gui
          rclone
          vicinae

          # alacritty
          foot
          ghostty
          # kitty

          env
          mime
          xdg
        ]
        # =================================================
        # KDE Plasma specific configurations
        # =================================================
        ++ lib.optionals nixosConfig.services.desktopManager.plasma6.enable [
          plasma-manager
        ]
        # =================================================
        # GNOME specific configurations
        # =================================================
        ++ lib.optionals nixosConfig.services.desktopManager.gnome.enable [
          dconf
        ];

      # home.enableNixpkgsReleaseCheck = false;
      home.stateVersion = nixosConfig.system.stateVersion;
    };
}
