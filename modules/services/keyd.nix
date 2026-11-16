{
  flake.modules.nixos.services =
    { config, lib, ... }:
    {
      config = lib.mkMerge [
        {
          # https://github.com/rvaiya/keyd
          # sudo nix run nixpkgs#keyd monitor
          services.keyd = {
            keyboards = {
              default = {
                ids = [ "*" ];
                settings = {
                  main = {
                    capslock = "overload(control, capslock)";
                  };
                }; # settings
              }; # default
            }; # keyboards
          }; # keyd
        }

        (lib.mkIf config.services.keyd.enable {
          # keyd 用 signal(SIGTERM, exit) 处理停止信号，退出码是 15 而非 0，不声明的话关机时
          # systemd 会记 "Failed with result 'exit-code'"。
          systemd.services.keyd.serviceConfig.SuccessExitStatus = [ 15 ];

          # 上游 chgid() 会 setgid 到 "keyd" 组：组不存在只打 WARNING，存在则让非 root
          # 用户能访问 keyd 的 IPC socket。
          users.groups.keyd = { };
        })
      ];
    };
}
