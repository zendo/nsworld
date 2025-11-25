{
  self,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./bcachefs-single.nix
    # ./btrfs-subvolumes.nix
    ./hardware-configuration.nix

    self.nixosModules.default
    self.nixosModules.homeManagerInit

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.cosmic
    # self.nixosModules.sway
    # self.nixosModules.niri
    # self.nixosModules.hyprland
  ];

  # programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    duf
    gdu
  ];

  # Desktop Environment
  services = {
    displayManager.autoLogin.user = "${username}";
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

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  users.users.${username} = {
    # pw: 123
    hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.efiSysMountPoint = "/efi";
      limine.enable = true;
    };
  };
}
