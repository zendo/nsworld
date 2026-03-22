/*
  rclone mount infini:/ ~/.mnt/infini --vfs-cache-mode full
  rclone mount svp: ~/.mnt/svp
  rclone mount :sftp:/ ~/.mnt/rmt \
    --sftp-host rmt \
    --sftp-user aaa \
    --sftp-key-file ~/.ssh/id_ed25519
*/
{
  flake.modules.homeManager.rclone =
    { config, ... }:
    {
      programs.rclone = {
        enable = true;
        # ╭────────────────────────╮
        # │ webdav@infini          │
        # ╰────────────────────────╯
        remotes.infini = {
          config = {
            type = "webdav";
            url = "https://hakata.infini-cloud.net/dav/";
            user = "mifox";
          };
          secrets.pass = config.sops.secrets."rclone_infini_pass".path;
          # secrets.pass = config.age.secrets."infini_pass".path;
          # FIXME: https://github.com/nix-community/home-manager/issues/8334
          # rclone config update infini
          mounts."/" = {
            # enable = true;
            mountPoint = "${config.home.homeDirectory}/.mnt/infini";
            options = {
              vfs-cache-mode = "full";
              allow-other = true;
            };
          };
        };
        # ╭────────────────────────╮
        # │ webdav@koofr           │
        # ╰────────────────────────╯
        remotes.koofr = {
          config = {
            type = "webdav";
            url = "https://app.koofr.net/dav/Koofr";
            user = "linzway@qq.com";
          };
          secrets.pass = config.sops.secrets."rclone_koofr_pass".path;
          mounts."/" = {
            # enable = true;
            mountPoint = "${config.home.homeDirectory}/.mnt/koofr";
            options = {
              vfs-cache-mode = "full";
              allow-other = true;
            };
          };
        };
        # ╭────────────────────────╮
        # │ sftp                   │
        # ╰────────────────────────╯
        remotes.svp.config = {
          type = "sftp";
          host = "svp";
          user = "zendo";
          key_file = "~/.ssh/id_ed25519";
        };
        remotes.rmt.config = {
          type = "sftp";
          host = "rmt";
          user = "aaa";
          key_file = "~/.ssh/id_ed25519";
        };

      };
    };
}
