/*
  # Network `default` active
  sudo virsh net-start default
  sudo virsh net-autostart default

  # Clipboard share
  apt install spice-vdagent (Guest)

  # Shared folders: https://wiki.nixos.org/wiki/Virt-manager#Shared_folders
  Memory: enable the shared memory
  Add filesystem: virtiofs ~/Documents/guest-shared
  Target Path: shared
  # on guest
  mkdir yoga
  sudo mount -t virtiofs shared ~/yoga

  # Windows Guest
  add tpm: tpm-crb、emulator、2.0
  https://www.spice-space.org/download.html  # spice-guest-tools

  # qemu iso emulator
  qemu-system-x86_64 -enable-kvm -m 8192 -cdrom result/iso
*/
{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.mods.virt.enable = lib.mkEnableOption "virtualisation customize.";

  config = lib.mkIf config.mods.virt.enable {

    programs = {
      # java.enable = true;
      virt-manager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # gnome-boxes
      # quickemu
      # virt-viewer # 远程查看程序
      bridge-utils # brctl: network bridge
      wl-clipboard # waydroid clipborad
      # win-virtio # needs ?
      # bottles # wine manager
      # scrcpy # android
      # yuzu
      # ---------- #
      # distrobox create -i archlinux
      distrobox
      # toolbox create -i quay.io/toolbx/arch-toolbox  / ubuntu-toolbox
      # toolbox
      # ---------- #
    ];

    virtualisation = {
      spiceUSBRedirection.enable = true; # USB passthrough
      libvirtd = {
        enable = true;
        # allowedBridges = ["br0"];
        qemu = {
          # runAsRoot = false;
          package = pkgs.qemu_kvm; # emulate only host architectures
          # swtpm.enable = true; # emulated TPM
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      # virtualbox = {
      #   host.enable = true;
      #   # host.enableExtensionPack = true;
      # };

      # docker = {
      #   enable = true;
      #   autoPrune.enable = true;
      #   enableOnBoot = true;
      # };

      podman = {
        enable = true;
        dockerCompat = true;
      };

      # containers = {
      #   enable = true;
      #   registries.search = [
      #     "docker.io"
      #     "quay.io"
      #     "registry.opensuse.org"
      #   ];
      # };

      # nix shell n\#android-tools
      # adb connect 192.168.240.112:5555
      # adb shell wm set-fix-to-user-rotation enabled  # force vertical
      # waydroid.enable = true;
    };

    # Cross compile
    # nix build .#legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform.hello
    # boot.binfmt.emulatedSystems = [
    #   "aarch64-linux" # nix build .#legacyPackages.aarch64-linux.hello
    # ];

    # boot.kernelParams =
    #   (lib.optionals config.hardware.cpu.intel.updateMicrocode [ "intel_iommu=on" "iommu=pt" ]);
  };
}
