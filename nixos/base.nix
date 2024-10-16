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
    earlyoom.enable = true;

    # auto-enable by services.graphical-desktop
    pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

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

  systemd.oomd.enable = false;

  programs = {
    zsh.enable = true;
    command-not-found.enable = false;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
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

  hardware.bluetooth.enable = config.services.graphical-desktop.enable;

  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = config.services.pipewire.enable;

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
}
