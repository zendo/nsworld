{
  config,
  lib,
  pkgs,
  ...
}:
with pkgs.lib;
  {
    options.meta = {
      username = mkOption {
        type = types.str;
        description = "The default username";
        default = "iab";
      };
      email = mkOption {
        type = types.str;
        description = "The default email";
        default = "linzway@qq.com";
      };
    };
  }
  {
    pkgs,
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.modules.desktop.kde;
    in {
      options.modules.desktop.kde = {
        enable = mkEnableOption "kde";
        config = mkIf cfg.enable {
          xserver = {
            enable = true;
            displayManager.sddm.enable = true;
            desktopManager.plasma5.enable = true;
          };
        };
      };
    }
