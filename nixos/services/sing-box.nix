{
  lib,
  pkgs,
  username,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    sing-box
  ];

  systemd.services.sing-box = {
    enable = lib.mkDefault false;
    # zashboard / metacubexd
    preStart = "[ -e $STATE_DIRECTORY/ui ] && rm -fr $STATE_DIRECTORY/ui; ln -sf ${pkgs.zashboard} $STATE_DIRECTORY/ui";
    serviceConfig = {
      StateDirectory = "sing-box";
      StateDirectoryMode = "0700";
      # RuntimeDirectory = "sing-box";
      # RuntimeDirectoryMode = "0700";
      ExecStart = "${lib.getExe pkgs.sing-box} run -c /home/${username}/code/sub/config.json -D \${STATE_DIRECTORY}";
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
