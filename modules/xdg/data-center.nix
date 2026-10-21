{
  flake.modules.nixos.data-center =
    { config, lib, ... }:
    lib.mkIf (config.fileSystems ? "/data") {

      systemd.tmpfiles.rules = [
        "d /data/.Trash-1000 0700 ${config.myVars.user} users - -"
        "d /data/archive 0755 ${config.myVars.user} users - -"
        "d /data/backup 0755 ${config.myVars.user} users - -"
        "d /data/books 0755 ${config.myVars.user} users - -"
        "d /data/docs 0755 ${config.myVars.user} users - -"
        "d /data/manga 0755 ${config.myVars.user} users - -"
        "d /data/music 0755 ${config.myVars.user} users - -"
        "d /data/pics 0755 ${config.myVars.user} users - -"
        "d /data/roms 0755 ${config.myVars.user} users - -"
        "d /data/share 2770 ${config.myVars.user} users - -"
        "d /data/temp 0755 ${config.myVars.user} users - -"
        "d /data/videos 0755 ${config.myVars.user} users - -"
      ];

    };

  flake.modules.hjem.data-center =
    { lib, osConfig, ... }:
    lib.mkIf (osConfig.fileSystems ? "/data") {

      files = {
        "Music".source = "/data/music";
        "Videos".source = "/data/videos";

        # LC_ALL=C xdg-user-dirs-update --force
        # rm ~/.config/gtk-3.0/bookmarks ; xdg-user-dirs-gtk-update
        # "user-dirs.conf".text = "enabled=False";
      };

    };
}
