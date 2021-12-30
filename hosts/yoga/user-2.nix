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

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
}
