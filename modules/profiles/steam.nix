{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        mangohud
        goverlay # mangohud config GUI
        ## wine
        # lutris
        # bottles
        # heroic
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
