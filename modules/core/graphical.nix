{
  flake.modules.nixos.graphical =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      i18n.defaultLocale = lib.mkDefault "zh_CN.UTF-8";

      services.keyd.enable = true;
      # services.kanata.enable = true;

      # FIXME: https://github.com/NixOS/nixpkgs/issues/149812
      environment.extraInit = ''
        export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      '';

      # Bluetooth
      # services.blueman.enable = true;
      hardware.bluetooth.enable = true;

      # Sounds
      security.rtkit.enable = config.services.pipewire.enable;
      services.pipewire = {
        # jack.enable = true;
      };

      # Make `xdg-open` works in FHS sandbox
      xdg.portal.xdgOpenUsePortal = true;

      # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      # flatpak install flathub io.github.kolunmi.Bazaar
      services.flatpak.enable = true;

      mods.fcitx = {
        enable = true;
        withPinyin = true;
        # withRime = true;
      };
      # or ibus
      # i18n.inputMethod = {
      #   enable = true;
      #   type = "ibus";
      #   ibus.engines = with pkgs.ibus-engines; [
      #     # libpinyin
      #     (rime.override {
      #       rimeDataPkgs = [
      #         pkgs.rime-ice
      #       ];
      #     })
      #   ];
      # };

    };
}
