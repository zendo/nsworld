/*
LC_ALL=C lscpu | grep Virtualization
dmesg | grep IOMMU

sudo virsh net-start default

Guest:
install spice-vdagent  # for clipboard share

qemu-system-x86_64 -enable-kvm -m 4096 -cdrom result/iso
*/
{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    virt-manager
    # bottles # wine manager
    # yuzu
    # gnome.gnome-boxes
    # steam-run
    # appimage-run
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      # allowedBridges = ["virbr0"];
      qemu = {
        ovmf.enable = true;     # UEFI
        # https://adamsimpson.net/writing/windows-11-as-kvm-guest
        package = pkgs.qemu_kvm; # emulate only host architectures
        # swtpm.enable = true; # emulated TPM
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

    # waydroid.enable = true;
  };

  # boot.kernelParams =
  #   (lib.optionals config.hardware.cpu.intel.updateMicrocode [ "intel_iommu=on" "iommu=pt" ]);

  users.users.${username}.extraGroups = [
    "lxd"
    "docker"
    "libvirtd"
    "qemu-libvirtd"
    "vboxusers"
    "adbusers"
  ];

  # services.flatpak.enable = true;

  # programs.adb.enable = true;

  # programs.steam.enable = true;

  # programs.java.enable = true;

  # programs.nix-ld.enable = true;
}
