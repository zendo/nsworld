{
  flake.modules.nixos.data-center =
    { config, lib, ... }:
    lib.mkIf (config.fileSystems ? "/data") {

      systemd.tmpfiles.rules = [
        "d /data/.Trash-1000 0700 ${config.myVars.user} users - -"
        "d /data/archives 0755 ${config.myVars.user} users - -"
        "d /data/backups 0755 ${config.myVars.user} users - -"
        "d /data/code 0755 ${config.myVars.user} users - -"
        "d /data/docs 0755 ${config.myVars.user} users - -"

        "d /data/media 0755 ${config.myVars.user} users - -"
        "d /data/media/music 0755 ${config.myVars.user} users - -"
        "d /data/media/videos 0755 ${config.myVars.user} users - -"
        "d /data/media/books 0755 ${config.myVars.user} users - -"
        "d /data/media/manga 0755 ${config.myVars.user} users - -"

        "d /data/pics 0755 ${config.myVars.user} users - -"
        "d /data/private 0700 ${config.myVars.user} users - -"
        "d /data/shared 2770 ${config.myVars.user} users - -"
        "d /data/temp 2775 ${config.myVars.user} users - -"
      ];

    };
}
