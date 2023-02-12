/*

  # check hardwave virtual supports
  LC_ALL=C lscpu | grep Virtualization
  dmesg | grep IOMMU

  # fix network `default` inactive
  sudo virsh net-start default
  sudo virsh net-autostart default

  Guest:
  spice-vdagent  # for clipboard share

  # share file
  sudo mkdir /mnt/vfs_share
  sudo chown iab /mnt/vfs_share
  mkdir share #guest
  sudo mount -t 9p -o trans=virtio share ~/share #guest

  qemu-system-x86_64 -enable-kvm -m 8192 -cdrom result/iso

*/
{ config, pkgs, lib, ... }: {

  # services.flatpak.enable = true;

  # programs.adb.enable = true;

  # programs.steam.enable = true;

  # programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    virt-manager
    bridge-utils
    # distrobox
    # bottles # wine manager
    # yuzu
    # gnome.gnome-boxes
    # steam-run
    # appimage-run
  ];

  virtualisation = {
    spiceUSBRedirection.enable = true; # USB passthrough
    libvirtd = {
      enable = true;
      # allowedBridges = ["virbr0"];
      qemu = {
        # runAsRoot = false;
        ovmf.enable = true; # UEFI
        # https://adamsimpson.net/writing/windows-11-as-kvm-guest
        package = pkgs.qemu_kvm; # emulate only host architectures
        # swtpm.enable = true;   # emulated TPM
        # ovmf.packages = [
        #   (pkgs.OVMFFull.override
        #     {
        #       secureBoot = true;
        #       tpmSupport = true;
        #     })
        # ];
      };
    };

    # virtualbox = {
    #   host.enable = true;
    #   # host.enableExtensionPack = true;
    # };

    # lxd = {
    #   enable = true;
    # }

    # docker = {
    #   enable = true;
    #   autoPrune.enable = true;
    #   enableOnBoot = true;
    # };

    # podman = {
    #   enable = true;
    #   # Create a `docker` alias for podman, to use it as a drop-in replacement
    #   dockerCompat = true;
    # };

    # containers = {
    #   enable = true;
    #   registries.search = [
    #     "docker.io"
    #     "quay.io"
    #     "registry.opensuse.org"
    #   ];
    # };

    # waydroid.enable = true;
  };

  # Cross compile
  # nix build .#legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform.hello
  # boot.binfmt.emulatedSystems = [
  #   "aarch64-linux" # nix build .#legacyPackages.aarch64-linux.hello
  # ];

  # boot.kernelParams =
  #   (lib.optionals config.hardware.cpu.intel.updateMicrocode [ "intel_iommu=on" "iommu=pt" ]);

  # Fix flatpak tofu and icons.
  # https://github.com/accelbread/config-flake/blob/master/nixos/common/flatpak-fonts.nix
  # system.fsPackages = [ pkgs.bindfs ];
  # fileSystems = lib.mapAttrs
  #   (_: v: v // {
  #     fsType = "fuse.bindfs";
  #     options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  #   })
  #   {
  #     "/usr/share/icons".device = "/run/current-system/sw/share/icons";
  #     "/usr/share/fonts".device = pkgs.buildEnv
  #       {
  #         name = "system-fonts";
  #         paths = config.fonts.fonts;
  #         pathsToLink = [ "/share/fonts" ];
  #       } + "/share/fonts";
  #   };
}
