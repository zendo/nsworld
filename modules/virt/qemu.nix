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
  flake.modules.nixos.qemu =
    { pkgs, lib, ... }:
    {
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
      ];

      networking.firewall = {
        # libvirt:虚拟网段 192.168.122.0/24。NixOS 的 libvirtd 模块只写自己的
        # table ip libvirt_network(只有 forward/nat hook),不管 INPUT。
        # 虚拟机向 192.168.122.1 要 DHCP(67)和 DNS(53)是 INPUT,
        # 不放行的话虚拟机开机就拿不到 IP / 解析不了域名。
        interfaces."virbr0" = {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [
            53
            67
          ];
        };
      };

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

        # nix shell n\#android-tools
        # adb connect 192.168.240.112:5555
        # adb shell wm set-fix-to-user-rotation enabled  # force vertical
        # https://www.reddit.com/r/NixOS/comments/1qnsqrb/waydroid_on_nixos_the_ultimate_guide_to
        # waydroid.enable = true;
      };

      # Cross compile
      # nix build .#legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform.hello
      # boot.binfmt.emulatedSystems = [
      #   "aarch64-linux" # nix build .#legacyPackages.aarch64-linux.hello
      # ];

    };

}
