{
  lib,
  pkgs,
  myvars,
  ...
}:
{
  systemd.services.rclone = {
    enable = lib.mkDefault false;
    description = "Rclone infini Mount Service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /mnt/infini";
      ExecStart = ''
        ${lib.getExe pkgs.rclone} mount \
        --config=/home/${myvars.user}/.config/rclone/rclone.conf \
        --vfs-cache-mode full \
        --allow-other \
        infini:/ /mnt/infini
      '';
      Restart = "on-failure";
    };
  };
}
