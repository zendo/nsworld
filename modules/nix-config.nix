{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable; # nix v2.5pre
    useSandbox = true;
    autoOptimiseStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    binaryCaches = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
