/*
sudo vi /etc/nix/nix.conf
experimental-features = nix-command flakes
substituters = https://mirror.sjtu.edu.cn/nix-channels/store
trusted-users = root @wheel iab

sudo sed -i '$aexport XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"' /etc/profile.d/nix.sh
*/
{
  config,
  pkgs,
  ...
}: {
  home.shellAliases = {
  };

  home.packages = with pkgs; [
    # radioboat
  ];
}
