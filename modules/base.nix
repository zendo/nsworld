{
  config,
  pkgs,
  ...
}: {
  zramSwap.enable = true;

  boot = {
    # tmpOnTmpfs = true;
    cleanTmpDir = true;
    plymouth.enable = true;
    initrd.systemd.enable = true;
    supportedFilesystems = ["ntfs"];
  };

  services = {
    # fwupd.enable = true;
    acpid.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    parted
    gptfdisk
    nix-bash-completions
  ];

  environment.variables = {
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron wayland support
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "22.05";
}
