{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.mods.fcitx;
in
{
  options.mods.fcitx = {
    enable = lib.mkEnableOption ''
      my fcitx5 customize.
    '';
  };

  config = lib.mkIf cfg.enable {
    # fix svg theme not showing
    programs.gdk-pixbuf.modulePackages = lib.mkDefault [ pkgs.librsvg ];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-fluent
        fcitx5-mellow-themes
        # fcitx5-chinese-addons
        (fcitx5-rime.override {
          rimeDataPkgs = [
            pkgs.rime-ice
          ];
        })
      ];
    };
  };
}
