{
  self,
  pkgs,
  myvars,
  ...
}:
{
  imports = [
    ./disko-bcachefs.nix
    # ./disko-btrfs.nix
    ./hardware-configuration.nix

    self.modules.nixos.default
    self.modules.nixos.hm

    self.modules.nixos.gnome
    # self.modules.nixos.kde
    # self.modules.nixos.cosmic
    # self.modules.nixos.niri
    # self.modules.nixos.sway
    # self.modules.nixos.hyprland
  ];

  # programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    duf
    gdu
  ];

  # Desktop Environment
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

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  users.users.${myvars.user} = {
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
