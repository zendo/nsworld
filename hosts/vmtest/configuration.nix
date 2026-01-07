{
  pkgs,
  lib,
  inputs,
  self,
  myvars,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"

    self.modules.nixos.default
    self.modules.nixos.hm

    self.modules.nixos.gnome
    # self.modules.nixos.kde
    # self.modules.nixos.cosmic
    # self.modules.nixos.niri
    # self.modules.nixos.sway
    # self.modules.nixos.hyprland
  ];

  disabledModules = [
    # "services/desktops/pipewire/pipewire.nix"
  ];

  # programs'.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    dippi
  ];

  environment.variables = { };

  services = {
    displayManager.autoLogin.user = "${myvars.user}";
    xserver = {
      # enable = true;
      desktopManager = {
        # gnome.enable = true;
        # xfce.enable = true;
        # budgie.enable = true;
        # deepin.enable = true;
        # cinnamon.enable = true;
        # pantheon.enable = true;
        # enlightenment.enable = true;
        # mate.enable = true;
        # lxqt.enable = true;
      };
    };
  };

  # boot.initrd.kernelModules = ["virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console"];

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;

  # ./result/bin/run-vm -m 4G -smp 4 -device virtio-vga-gl -display sdl,gl=on
  virtualisation = {
    memorySize = 1024 * 4;
    diskSize = 1024 * 8;
    cores = 8;
    msize = 104857600; # 100M
    qemu = {
      options = [
        # Sounds
        "-audiodev pa,id=snd0"
        "-device ich9-intel-hda"
        "-device hda-duplex,audiodev=snd0"
        # Graphical for sway
        # "-vga qxl"
        # Wayland in QEMU
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users = {
    # pw: root
    root.initialHashedPassword = lib.mkForce "$y$j9T$0t8NyDpq3ikgERiGgdPru0$pI6bTECjj2pSb68lF.U0xpftH.2vTF26uiRasZnROD3";
    # pw: test
    ${myvars.user}.initialHashedPassword =
      lib.mkForce "$y$j9T$cwgM31P53Jvlqq2Ed/ad0.$t1G8tnJg7DsspO2687hpTO87v2uSVfB9E5hpBufYhR.";
  };

  # home-manager.users.${myvars.user} = { };
}
