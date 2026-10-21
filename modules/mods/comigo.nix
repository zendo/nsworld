{
  flake.modules.nixos.mods =
    { lib, pkgs, ... }:
    {
      systemd.services.comigo = {
        enable = lib.mkDefault false;
        after = [ "network.target" ];
        wants = [ "network.target" ];
        environment = {
          HOME = "%S/comigo";
          COMIGO_PORT = "1234";
          COMIGO_ENABLE_UPLOAD = "true";
        };
        serviceConfig = {
          StateDirectory = "comigo";
          StateDirectoryMode = "0700";
          ExecStart = "${lib.getExe pkgs.comigo} --no-tui";
          Restart = "on-failure";
          DynamicUser = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
