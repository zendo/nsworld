{
  lib,
  pkgs,
  ...
}:
{
  systemd.services.sub-store = {
    enable = lib.mkDefault false;
    serviceConfig = {
      StateDirectory = "sub-store";
      StateDirectoryMode = "0700";
      # RuntimeDirectory = "sub-store";
      # RuntimeDirectoryMode = "0700";
      Environment = [
        "SUB_STORE_DATA_BASE_PATH=/var/lib/sub-store"
        "SUB_STORE_FRONTEND_PATH=${pkgs.sub-store}/frontend"
        "SUB_STORE_BACKEND_API_HOST=127.0.0.1"
        "SUB_STORE_BACKEND_API_PORT=3000"
        "SUB_STORE_FRONTEND_HOST=127.0.0.1"
        "SUB_STORE_FRONTEND_PORT=3001"
      ];
      ExecStart = "${lib.getExe pkgs.nodejs} ${pkgs.sub-store}/sub-store.bundle.js";
      # Restart = "on-failure";
      # DynamicUser = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  # node $SUB_STORE_DATA_BASE_PATH/sub-store.bundle.js > $SUB_STORE_DATA_BASE_PATH/run.log 2> $SUB_STORE_DATA_BASE_PATH/error.log &
}
