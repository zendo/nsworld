{
  config,
  pkgs,
  inputs,
  username,
  ...
}: {
  # disabledModules = ["services/desktops/pipewire/pipewire.nix"];
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
    ../modules/base.nix
    ../modules/network.nix
    ../modules/nixconfig.nix
    ../modules/sound.nix
    ../modules/gnome.nix
  ];

  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    memorySize = 1024 * 3;
    diskSize = 1024 * 8;
    cores = 4;
    msize = 104857600;
  };

  users.users.root = {
    password = "root";
  };
  users.users.${username} = {
    password = "test";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
