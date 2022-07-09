/*
--option substituters "https://mirror.sjtu.edu.cn/nix-channels/store"

experimental-features = nix-command flakes
substituters = https://mirror.sjtu.edu.cn/nix-channels/store

trusted-users = root @wheel iab
*/
{
  config,
  pkgs,
  ...
}: {
  home.shellAliases = {
  };

}
