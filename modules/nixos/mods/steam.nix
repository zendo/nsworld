{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.mods.steam.enable = lib.mkEnableOption "steam customize.";

  config = lib.mkIf config.mods.steam.enable {
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
