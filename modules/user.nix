{config, username, ...}: {
  # refuse using useradd
  users.mutableUsers = false;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  services.xserver.displayManager.autoLogin.user = "${username}";

  users.users.${username} = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$1uAdBaFQVioF3CM1$n5BXqp7m6ZW41eIaBnrHc/9Aa25b7ux3QAy3.SwcxsTUHwCSFUZ2Qh2oEJUz02Wqg/Sg8Muw5YYgkTr3XZ9Pn1";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
  };

  users.users.zen = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$1uAdBaFQVioF3CM1$n5BXqp7m6ZW41eIaBnrHc/9Aa25b7ux3QAy3.SwcxsTUHwCSFUZ2Qh2oEJUz02Wqg/Sg8Muw5YYgkTr3XZ9Pn1";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
  };
}
