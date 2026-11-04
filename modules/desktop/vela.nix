{
  flake.modules.nixos.vela =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.vela ];

      # Register share/wayland-sessions/vela.desktop with the display manager.
      services.displayManager.sessionPackages = [ pkgs.vela ];
      services.displayManager.defaultSession = lib.mkDefault "vela";

      # A small Wayland-capable greeter. Disable this if another display
      # manager (GDM, SDDM, greetd, ...) is already configured.
      services.displayManager.ly.enable = lib.mkDefault true;

      # The lock screen authenticates through PAM.
      security.pam.services.vela-lock = { };
      security.polkit.enable = true;

      # Graphical services, PipeWire, fonts, XDG dirs and xdg-autostart.
      services.graphical-desktop.enable = true;
      programs.xwayland.enable = lib.mkDefault true;
      programs.dconf.enable = lib.mkDefault true;

      # Vela's session target is a user unit shipped by the package.
      systemd.packages = [ pkgs.vela ];

      # Desktop integration used by the shell and Files.
      services.gvfs.enable = true;
      services.udisks2.enable = true;
      services.upower.enable = true;

      # XDG portals: GTK for generic dialogs, wlr for screencast/screenshot.
      # Vela supplies its own per-desktop chooser in
      # $out/etc/xdg/xdg-desktop-portal-wlr/Vela.
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-wlr
        ];
        config = {
          common.default = [ "gtk" ];
          Vela = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
          };
        };
      };
      environment.etc."xdg/xdg-desktop-portal-wlr/Vela".source =
        "${pkgs.vela}/etc/xdg/xdg-desktop-portal-wlr/Vela";

      # DDC/CI brightness on display adapters: Vela's udev rule grants the
      # active session's user access, and the kernel needs i2c-dev loaded.
      services.udev.packages = [ pkgs.vela ];
      boot.kernelModules = [ "i2c-dev" ];
    };
}
