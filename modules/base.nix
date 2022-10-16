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
    # https://github.com/NixOS/nixpkgs/pull/185116
    # initrd.systemd.enable = true;
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
