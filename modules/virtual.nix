{
  config,
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # bottles # wine manager
    # yuzu
    # gnome.gnome-boxes
    # virt-manager
  ];

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

    # https://adamsimpson.net/writing/windows-11-as-kvm-guest
    libvirtd = {
      # enable = true;
      qemu = {
        package = pkgs.qemu_kvm; # emulate only host architectures
        swtpm.enable = true; # emulated TPM
        ovmf.packages = [
          (pkgs.OVMFFull.override
            {
              secureBoot = true;
              tpmSupport = true;
            })
        ];
      };
    };
    # boot.initrd.kernelModules = ["virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console"];

    # virtualbox = {
    #   host.enable = true;
    # };

    # lxd = {
    #   enable = true;
    # }

    # waydroid.enable = true;
  };

  # services.flatpak.enable = true;

  # programs.adb.enable = true;

  # programs.steam.enable = true;

  # programs.nix-ld.enable = true;
}
