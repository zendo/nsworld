{
  flake.modules.nixos.selfhosted =
    { config, lib, ... }:
    {
      config = lib.mkIf config.services.immich.enable {
        services.immich = {
          host = "127.0.0.1";
          port = config.myVars.ports.immich;
          mediaLocation = lib.mkDefault "/data/media/immich";

          # 人脸 / 物体识别模型很吃内存(几百 MB 起),小机器默认关,
          # 需要搜索功能时在 host 侧覆盖成 true
          machine-learning.enable = lib.mkDefault false;

          # 其余配置(分享域名等)留空 = 走 Web 界面的 Admin > Settings,
          # settings 一旦非 null 就会生成 config.json,部分界面选项会变只读
        };
      };
    };
}
