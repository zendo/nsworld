{ config, ... }: {

  dconf.settings = {
    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      click-method = "areas";
    };

    "org/gnome/desktop/interface" = {
      cursor-theme = "Adwaita";
      icon-theme = "Adwaita";
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "terminate:ctrl_alt_bksp" "ctrl:swapcaps" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [ ];
      close = [ "<Super>q" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      move-to-workspace-1 = [ "<Alt>1" ];
      move-to-workspace-2 = [ "<Alt>2" ];
      move-to-workspace-3 = [ "<Alt>3" ];
      move-to-workspace-4 = [ "<Alt>4" ];
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "gsconnect@andyholmes.github.io"
        "dash-to-dock@micxgx.gmail.com"
        "clipboard-history@alexsaveau.dev"
        "space-bar@luchrioh"
        "gradienttopbar@pshow.org"
        "nightthemeswitcher@romainvigier.fr"
        "caffeine@patapon.info"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
      favorite-apps = [
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "emacs.desktop"
        "firefox.desktop"
        "org.telegram.desktop.desktop"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      custom-theme-shrink = true;
      apply-custom-theme = true;
      hot-keys = false;
      show-trash = false;
      click-action = "focus-minimize-or-previews";
    };

    "org/gnome/shell/extensions/space-bar/behavior" = {
      show-empty-workspaces = false;
    };
  };
}
