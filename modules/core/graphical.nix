{
  flake.modules.nixos.graphical =
    { pkgs, config, ... }:
    {
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
        # withPinyin = true;
        withRime = true;
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
