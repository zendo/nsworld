{ config, ... }:
{
  sops.secrets."rclone_infini_pass" = { };

  programs.rclone = {
    enable = true;
    ### webdav@infini ###
    remotes.infini = {
      config = {
        type = "webdav";
        url = "https://hakata.infini-cloud.net/dav/";
        user = "mifox";
      };
      secrets.pass = config.sops.secrets."rclone_infini_pass".path;
      # FIXME: https://github.com/nix-community/home-manager/issues/8334
      # rclone config update infini
      mounts."/" = {
        enable = true;
        mountPoint = "${config.home.homeDirectory}/.mnt/infini";
        options = {
          vfs-cache-mode = "full";
          allow-other = true;
        };
      };
    };
    ### webdav@infini ###
  };
}
