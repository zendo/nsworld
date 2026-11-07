{
  flake.modules.nixos.selfhosted =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      systemd.services.dynacat = {
        enable = lib.mkDefault false;
        description = "Dynacat dashboard server";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "nss-user-lookup.target"
        ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.dynacat} --config /home/${config.myVars.user}/nsworld/modules/selfhosted/assets/dynacat.yml";
          Restart = "on-failure";
          WorkingDirectory = "/var/lib/dynacat";
          StateDirectory = "dynacat";
          CacheDirectory = "dynacat";
          # RuntimeDirectory = "dynacat";
        };
      };
    };
}
