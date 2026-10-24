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
        "d /data/docs/books 0755 ${config.myVars.user} users - -"
        "d /data/docs/manga 0755 ${config.myVars.user} users - -"

        "d /data/media 0755 ${config.myVars.user} users - -"
        "d /data/media/music 0755 ${config.myVars.user} users - -"
        "d /data/media/videos 0755 ${config.myVars.user} users - -"

        "d /data/pics 0755 ${config.myVars.user} users - -"
        "d /data/shared 2770 ${config.myVars.user} users - -"
        "d /data/temp 0755 ${config.myVars.user} users - -"
      ];

    };

  flake.modules.hjem.data-center =
    { lib, osConfig, ... }:
    lib.mkIf (osConfig.fileSystems ? "/data") {

      files = {
        "Music".source = "/data/media/music";
        "Videos".source = "/data/media/videos";

        # LC_ALL=C xdg-user-dirs-update --force
        # rm ~/.config/gtk-3.0/bookmarks ; xdg-user-dirs-gtk-update
        # "user-dirs.conf".text = "enabled=False";
      };

    };
}
