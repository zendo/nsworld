{
  pkgs,
  lib,
  inputs,
  self,
  username,
  ...
}:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"

    # self.nixosModules.gnome
    self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  disabledModules = [
    # "services/desktops/pipewire/pipewire.nix"
  ];

  mods.virt.enable = false;
  # mods.daeWithConfig.enable = true;

  environment.systemPackages = with pkgs; [
    git
    firefox
    notes
  ];

  environment.variables = { };

  services.xserver = {
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
    # displayManager.autoLogin.user = lib.mkForce "guest";
    xkb.options = "ctrl:swapcaps"; # Xorg Layout
  };

  # boot.initrd.kernelModules = ["virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console"];

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;

  virtualisation = {
    memorySize = 1024 * 3;
    diskSize = 1024 * 8;
    cores = 4;
    msize = 104857600; # 100M
    qemu = {
      options = [
        # Sounds
        "-audiodev pa,id=snd0"
        "-device ich9-intel-hda"
        "-device hda-duplex,audiodev=snd0"
        # Graphical for sway
        # "-vga qxl"
      ];
    };
  };

  users.users.root.password = "root";
  # psaawd: test
  users.users.${username}.hashedPassword = lib.mkForce "$y$j9T$cwgM31P53Jvlqq2Ed/ad0.$t1G8tnJg7DsspO2687hpTO87v2uSVfB9E5hpBufYhR.";

  home-manager.users.${username} = { };
}
