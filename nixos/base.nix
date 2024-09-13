{
  lib,
  pkgs,
  config,
  ...
}:
{
  boot = {
    plymouth.enable = true;

    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = !config.boot.tmp.useTmpfs;
    };

    initrd.systemd = {
      enable = lib.mkDefault true;
      # root = "gpt-auto";
    };

    kernelParams = lib.optionals config.boot.initrd.systemd.enable [ "systemd.show_status=false" ];
  };

  services = {
    fwupd.enable = true;
    acpid.enable = true;

    zram-generator = {
      enable = lib.mkDefault true;
      settings.zram0 = {
        compression-algorithm = "zstd";
        zram-size = "ram / 2";
      };
    };

    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    curl
    parted
    gptfdisk
    micro
    sniffglue
    nix-bash-completions
    sbctl
    efibootmgr
    # efitools
  ];

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # make `xdg-open` works inside FHS envs
  xdg.portal.xdgOpenUsePortal = true;

  documentation = {
    enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.11";

  # Remove perl from activation
  # system.etc.overlay.enable = lib.mkDefault true;
  services.userborn.enable = lib.mkDefault true;
}
