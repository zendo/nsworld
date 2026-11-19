let
  # hydro 调成 pure 的样子：全路径、两行、灰分支、紫 ❯、>5s 显黄耗时
  hydroConfig = ''
    set -g fish_prompt_pwd_dir_length 100
    set -g hydro_multiline true
    set -g hydro_symbol_start '\n'
    set -g hydro_symbol_prompt ❯
    set -g hydro_color_pwd blue
    set -g hydro_color_git brblack
    set -g hydro_color_prompt magenta
    set -g hydro_color_duration yellow
    set -g hydro_cmd_duration_threshold 5000

    # hydro 会把上条的退出码打在路径行尾（`| 130`），这里只保留变红的 ❯，同 pure。
    # conf.d 先于本文件加载，所以这个 handler 注册在 hydro 自己的之后。
    function _hydro_hide_status --on-event fish_postexec
        set -g _hydro_status (string replace --regex -- '\| [0-9 ]+ ' "" $_hydro_status)
    end
  '';
in
{
  flake.modules.nixos.fish = { pkgs, ... }: {

    environment.systemPackages = with pkgs; [
      # fishPlugins.pure
      # fishPlugins.tide
      fishPlugins.hydro
    ];

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting
      ''
      + hydroConfig;
    };

    # 想默认用 fish 的机器自己开：
    # users.defaultUserShell = pkgs.fish;
  };
}
