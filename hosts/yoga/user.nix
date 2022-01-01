{ config, ... }:

{
  users.users.iab = {
    isNormalUser = true;
    password = "123";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
  };

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;
}
