{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    lib.mkIf (config.services.rqbit.enable) {

      services.rqbit = {
        openFirewall = config.networking.firewall.enable;
        httpHost = "0.0.0.0";
        httpPort = 3039;
        downloadDir = lib.mkDefault "/data/temp";
      };

      # Allow rqbit to access downloadDir.
      users.users.rqbit.extraGroups = [ "users" ];
      # Allow group members to modify downloaded files.
      systemd.services.rqbit.serviceConfig.UMask = lib.mkForce "0002";
    };
}
