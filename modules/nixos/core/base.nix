{
  lib,
  config,
  pkgs,
  ...
}:
{
  # Load configs from nixos/modules
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/149812
  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';

  documentation = {
    enable = lib.mkDefault false;
    doc.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  # Filesystem
  services.btrfs.autoScrub.enable =
    config.fileSystems ? "/" && config.fileSystems."/".fsType == "btrfs";
  services.bcachefs.autoScrub.enable =
    config.fileSystems ? "/" && config.fileSystems."/".fsType == "bcachefs";
}
