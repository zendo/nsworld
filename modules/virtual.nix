{
  config,
  pkgs,
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

    # waydroid.enable = true;
  };

  # services.flatpak.enable = true;

  # programs.steam.enable = true;
  # use NixOS libraries instead of Steam-provided
  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     nativeOnly = true;
  #   };
  # };
}
