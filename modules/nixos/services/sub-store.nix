{
  lib,
  pkgs,
  ...
}:
{
  # REF: https://surge.tel/08/2930 & https://hub.docker.com/r/xream/sub-store
  # FRONTEND: http://127.0.0.1:3001/subs
  # BACKEND: curl -O "http://127.0.0.1:3000/download/collection/all?target=sing-box"
  systemd.services.sub-store = {
    enable = lib.mkDefault false;
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    environment = {
      # SUB_STORE_BACKEND_SYNC_CRON = "55 23 * * *"; # 23:55
      # SUB_STORE_FRONTEND_BACKEND_PATH = "/2cXaAxRGfddmGz2yx1wA";
      SUB_STORE_DATA_BASE_PATH = "%S/sub-store";
      SUB_STORE_FRONTEND_PATH = "${pkgs.sub-store}/frontend";
      SUB_STORE_FRONTEND_HOST = "::";
      SUB_STORE_FRONTEND_PORT = "3001";
      SUB_STORE_BACKEND_API_HOST = "::";
      SUB_STORE_BACKEND_API_PORT = "3000";
    };
    serviceConfig = {
      StateDirectory = "sub-store";
      StateDirectoryMode = "0700";
      ExecStart = "${lib.getExe pkgs.nodejs} ${pkgs.sub-store}/sub-store.bundle.js";
      Restart = "on-failure";
      DynamicUser = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
