{
  lib,
  pkgs,
  ...
}:
{
  # REF: https://surge.tel/08/2930 & https://hub.docker.com/r/xream/sub-store
  systemd.services.sub-store = {
    enable = lib.mkDefault false;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    environment = {
      SUB_STORE_DATA_BASE_PATH = "%S/sub-store";
      SUB_STORE_FRONTEND_PATH = "${pkgs.sub-store-frontend}";
      SUB_STORE_BACKEND_API_HOST = "::";
      SUB_STORE_BACKEND_API_PORT = "3000";
      SUB_STORE_BACKEND_MERGE = "true";
      # openssl rand -base64 12
      SUB_STORE_FRONTEND_BACKEND_PATH = "/kewejyo3baNXPELk";
      # SUB_STORE_BACKEND_SYNC_CRON = "55 23 * * *"; # 23:55
    };
    serviceConfig = {
      StateDirectory = "sub-store";
      StateDirectoryMode = "0700";
      ExecStart = "${lib.getExe pkgs.sub-store}";
      Restart = "on-failure";
      DynamicUser = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
