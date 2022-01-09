{ config, ... }:

{
  users.users.iab = {
    isNormalUser = true;
    password = "123"; # Don't learn me
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
