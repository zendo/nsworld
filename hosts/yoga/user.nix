{ config, ... }:

{
  users.users.iab = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$v1weho0Gt9LsSZN5$wCuadG7X5sPHo4gaobFv1fIXZ.J94npoJS3wYvSc/okqXEwYHn0ZVT0bHX1fm4PAYOyBMeAfvUJO5mb0tt/sI/";
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
