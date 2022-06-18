{
  config,
  pkgs,
  username,
  ...
}: {
  virtualisation = {
    # docker = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   enableOnBoot = true;
    # };

    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
    };

    # libvirtd = {
    #   enable = true;
    #   qemu.runAsRoot = false;
    # };

    # virtualbox = {
    #   host.enable = true;
    # };

    # needs channel
    # https://github.com/jollheef/appvm
    # appvm = {
    #   enable = true;
    #   user = "${username}";
    # };

    # waydroid.enable = true;
  };

  # services.flatpak.enable = true;

  # programs.adb.enable = true;

  # programs.steam.enable = true;
}
