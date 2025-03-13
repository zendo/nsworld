{
  lib,
  pkgs,
  username,
  ...
}:
{
  systemd.services.sing-box = {
    # enable = false;
    preStart = "ln -sf ${pkgs.metacubexd} $STATE_DIRECTORY/ui";
    serviceConfig = {
      StateDirectory = "sing-box";
      StateDirectoryMode = "0700";
      # RuntimeDirectory = "sing-box";
      # RuntimeDirectoryMode = "0700";
      ExecStart = "${lib.getExe pkgs.sing-box} run -c /home/${username}/.sub/config.json -D \${STATE_DIRECTORY}";
      Restart = "on-failure";
      # DynamicUser = true;
    };
    wantedBy = [ "multi-user.target" ];
  };

  /*
    services.sing-box = {
      enable = true;
      settings = {
      };
    };
  */
}
