{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Only enable on Desktop
  hardware.bluetooth.enable = config.services.graphical-desktop.enable;

  # This allows PipeWire to run with realtime privileges (i.e: less cracks)
  security.rtkit.enable = config.services.pipewire.enable;

  # Make `xdg-open` works inside FHS envs
  xdg.portal.xdgOpenUsePortal = true;

  zramSwap.enable = lib.mkDefault true;

  boot = {
    plymouth.enable = true;

    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault true;
    };

    initrd.systemd = {
      enable = lib.mkDefault true;
      # root = "gpt-auto";
    };

    kernelParams = lib.optionals config.boot.initrd.systemd.enable [ "systemd.show_status=false" ];
  };

  services = {
    acpid.enable = true;
    # fwupd.enable = true;
    btrfs.autoScrub.enable = config.fileSystems."/".fsType == "btrfs";

    # auto-enabled by `services.graphical-desktop`
    pipewire = {
      # alsa.support32Bit = true;
      # jack.enable = true;
    };

    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };

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
    sbctl
    efibootmgr
    # efitools
  ];

  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.05";
  documentation.enable = lib.mkDefault false;

  # nixos-rebuild-ng: Python-based re-implementation
  system.rebuild.enableNg = true;

  # Remove perl from activation
  # system.etc.overlay.enable = lib.mkDefault true;
}
