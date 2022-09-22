{
  config,
  username,
  pkgs,
  ...
}: {
  # Refuse using `useradd`
  users.mutableUsers = false;
  # users.defaultUserShell = pkgs.zsh;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  users.users.${username} = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$7LRbX.zmB4lDy/AS$Hi8rzhlSgCTpKsUS/TtdYKNq4ZQfLMMOYmc7jqyD86qK0sL5BWb1FnvzDzMfbzlXg41I76c7/C/g8aBBakSIL0";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "lxd"
      "docker"
      "libvirtd"
      "vboxusers"
      "adbusers"
    ];
  };

  # users.users.zen = {
  #   isNormalUser = true;
  #   # mkpasswd -m sha-512
  #   hashedPassword = "$6$7LRbX.zmB4lDy/AS$Hi8rzhlSgCTpKsUS/TtdYKNq4ZQfLMMOYmc7jqyD86qK0sL5BWb1FnvzDzMfbzlXg41I76c7/C/g8aBBakSIL0";
  #   extraGroups = [
  #     "wheel"
  #     "networkmanager"
  #     "video"
  #     "audio"
  #     "docker"
  #     "libvirtd"
  #   ];
  # };
}
