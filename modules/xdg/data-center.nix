{
  flake.modules.nixos.data-center =
    { config, lib, ... }:
    lib.mkIf (config.fileSystems ? "/data") {

      systemd.tmpfiles.rules = [
        "d /data 0755 ${config.myVars.user} users - -"
        "d /data/.Trash 1777 root root - -"

        "d /data/archives 0750 ${config.myVars.user} users - -"
        "d /data/backups 0750 ${config.myVars.user} users - -"

        "d /data/code 0755 ${config.myVars.user} users - -"
        "d /data/docs 0755 ${config.myVars.user} users - -"

        "d /data/media 0755 ${config.myVars.user} users - -"
        "d /data/media/music 0755 ${config.myVars.user} users - -"
        "d /data/media/videos 0755 ${config.myVars.user} users - -"
        "d /data/media/books 0755 ${config.myVars.user} users - -"
        "d /data/media/manga 0755 ${config.myVars.user} users - -"

        "d /data/pics 0755 ${config.myVars.user} users - -"
        "d /data/private 0700 ${config.myVars.user} users - -"

        # 2770 = setgid + 组读写，组外不可见。
        # setgid 只保证新文件属组是 users；文件权限仍受 umask 影响（默认 022 → 0644，
        # 组内只能读）。默认 ACL 让新文件/新目录继续带组写权限，才是真正可协作的共享目录。
        "d /data/shared 2770 ${config.myVars.user} users - -"
        "a+ /data/shared - - - - d:u::rwx,d:g::rwx,d:o::---,d:m::rwx"

        # 公共临时目录：setgid + 组写 + sticky（组内不能删改别人的文件），组外不可见。
        # 若希望所有本地用户都能写（不限于 users 组），可改成 1777。
        "d /data/temp 3770 ${config.myVars.user} users - -"
      ];

    };
}
