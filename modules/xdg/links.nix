{ inputs, ... }:
{
  flake.modules.homeManager.links =
    { config, lib, ... }:
    let
      staticDot = dir: (inputs.self + /dotfiles/${dir});
      linkDot =
        dir: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nsworld/dotfiles/${dir}";
    in
    {
      home.file = {
        ".pi/agent/prompts".source = linkDot "pi/agent/prompts";
      };

      # ~/.config
      xdg.configFile = {
        "doom/config.org".source = linkDot "org/doom-emacs.org";
        "emacs/all-emacs.org".source = linkDot "org/all-emacs.org";

        "sway/config".source = linkDot "sway/config";
        "niri/configs".source = linkDot "niri/configs";
        "niri/config.kdl".source = linkDot "niri/config.kdl";
        "hypr/hyprland.lua".source = linkDot "hypr/hyprland.lua";

        "micro/settings.json".text = lib.generators.toJSON { } {
          autosu = true;
          softwrap = true;
          hlsearch = true;
          saveundo = true;
          scrollbar = true;
          mkparents = true;
          diffgutter = true;
        };

        # rime for ibus
        "ibus/rime/default.custom.yaml".source = staticDot "rime/default.custom.yaml";
        "ibus/rime/rime_ice.custom.yaml".source = staticDot "rime/rime_ice.custom.yaml";
        "ibus/rime/ibus_rime.custom.yaml".text = ''
          patch:
            style:
              horizontal: true
        '';
      };

      # ~/.local/share
      xdg.dataFile = {
        # rime for fcitx5
        "fcitx5/rime/default.custom.yaml".source = staticDot "rime/default.custom.yaml";
        "fcitx5/rime/rime_ice.custom.yaml".source = staticDot "rime/rime_ice.custom.yaml";
      };
    };

  flake.modules.hjem.links =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      linkDot = dir: "/home/${config.user}/nsworld/dotfiles/${dir}";
    in
    {
      files = {
        ".pi/agent/prompts".source = linkDot "pi/agent/prompts";
      };

      # ~/.config
      xdg.config.files = {
        # LC_ALL=C xdg-user-dirs-update --force
        # "user-dirs.conf".text = "enabled=False";

        # AutoStart
        # "autostart/helixnotes.desktop".source = "${pkgs.helixnotes}/share/applications/HelixNotes.desktop";

        "doom/config.org".source = linkDot "org/doom-emacs.org";
        "emacs/all-emacs.org".source = linkDot "org/all-emacs.org";

        "sway/config".source = linkDot "sway/config";
        "niri/configs".source = linkDot "niri/configs";
        "niri/config.kdl".source = linkDot "niri/config.kdl";
        "hypr/hyprland.lua".source = linkDot "hypr/hyprland.lua";

        "micro/settings.json" = {
          generator = lib.generators.toJSON { };
          value = {
            autosu = true;
            softwrap = true;
            hlsearch = true;
            saveundo = true;
            scrollbar = true;
            mkparents = true;
            diffgutter = true;
          };
        };

        "ibus/rime/default.custom.yaml".source = linkDot "rime/default.custom.yaml";
        "ibus/rime/rime_ice.custom.yaml".source = linkDot "rime/rime_ice.custom.yaml";
        "ibus/rime/ibus_rime.custom.yaml".text = ''
          patch:
            style:
              horizontal: true
        '';
      };

      # ~/.local/share
      xdg.data.files = {
        "fcitx5/rime/default.custom.yaml".source = linkDot "rime/default.custom.yaml";
        "fcitx5/rime/rime_ice.custom.yaml".source = linkDot "rime/rime_ice.custom.yaml";
      };
    };
}
