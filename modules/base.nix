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
    # initrd.systemd.enable = true;
    supportedFilesystems = ["ntfs"];
  };

  services = {
    fwupd.enable = true;
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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Need channels to work
  programs.command-not-found.enable = false;

  documentation = {
    enable = false;
    nixos.enable = false;
  };

  time.timeZone = "Asia/Shanghai";

  # location.provider = "geoclue2";
  # getip j
  # location = {
  #   latitude = 23.12911;
  #   longitude = 113.264385;
  # };

  system.stateVersion = "22.05";
}
