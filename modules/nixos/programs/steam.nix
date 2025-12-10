{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.programs'.steam.enable = lib.mkEnableOption "steam customize.";

  config = lib.mkIf config.programs'.steam.enable {
    environment.systemPackages = with pkgs; [
      mangohud
      goverlay # mangohud config GUI
    ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
