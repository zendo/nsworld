{ inputs, ... }:
{
  flake.modules.homeManager.mpv =
    { pkgs, ... }:
    {
      programs.mpv = {
        enable = true;
        package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.wrap-mpv;
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.wrap-mpv = inputs.wrapper-modules.wrappers.mpv.wrap {
        inherit pkgs;
        package = (
          pkgs.mpv.override {
            youtubeSupport = false; # :yt-dlp
            scripts = with pkgs.mpvScripts; [
              mpris
              # uosc
              inhibit-gnome
              thumbfast
              modernz
            ];
          }
        );
        "mpv.conf".content = ''
          # press: i

          # 预设一套高质量渲染设置，性能不够时注释
          profile=gpu-hq

          # 更现代的渲染后端
          # vo=gpu-next 默认设置
          hwdec=vulkan
          gpu-api=vulkan

          # 快进时左上角显示进度消息
          osd-on-seek=msg

          # save-position-on-quit=yes

          # 禁用系统缩放，让 mpv 自己处理
          hidpi-window-scale=no

          # [pyradio]
          # volume=80
        '';
        "mpv.input".content = ''
          UP   add volume 1 # 提高音量
          DOWN add volume -1 # 降低音量

          # MBTN_LEFT  cycle pause # 左键-单击 切换 暂停状态
          # MBTN_RIGHT ignore # 右键-单击 无操作

          > playlist-next  # skip to the next file
          < playlist-prev  # skip to the previous file
          #F8 show_text ''${playlist}

          h     cycle fullscreen
          ENTER cycle fullscreen
          ESC   quit
        '';
      };
    };
}
