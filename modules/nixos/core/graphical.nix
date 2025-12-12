{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Only enable on Desktop
  config = lib.mkIf config.services.graphical-desktop.enable {

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
    };

    # Sounds
    security.rtkit.enable = config.services.pipewire.enable;
    services.pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

    # Make `xdg-open` works in FHS sandbox
    xdg.portal.xdgOpenUsePortal = true;

    # fcitx or ibus
    mods.fcitx = {
      enable = true;
      # withPinyin = true;
      withRime = true;
    };
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
