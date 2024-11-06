{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  services = {
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
  };

  # mods.fcitx.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      # libpinyin
      (rime.override {
        rimeDataPkgs = [
          # pkgs.rime-frost
          pkgs.rime-ice
        ];
      })
    ];
  };

  # environment.systemPackages = with pkgs; [ ];
}
