{ config, ... }:

{
  users.users.zen = {
    isNormalUser = true;
    password = "111";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker" ];
  };

}
