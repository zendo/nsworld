/*
  nix build .#nixosConfigurations.livecd.config.system.build.isoImage
  nixos-rebuild build-image --image-variant iso-installer --flake .#livecd
  qemu-system-x86_64 -enable-kvm -m 8192 -cdrom result/iso/
  https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
*/
{ inputs, ... }:
{
  flake.nixosConfigurations.livecd = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.host-livecd
    ];
  };

  flake.modules.nixos.host-livecd =
    {
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
        # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
        # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma6.nix"
        # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
      ];

      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        supportedFilesystems = {
          # bcachefs = true;
          zfs = lib.mkForce false; # always broken
        };
      };

      environment.systemPackages = with pkgs; [
        # Make copying cache from local://
        # (inputs.self.nixosConfigurations.yoga.config.system.build.toplevel)
        tree
        file
        bind
        wget
        curl
        micro
        fresh-editor
        parted
        gptfdisk
        efibootmgr

        fd
        ripgrep
        gdu
        duf
        dysk
        btop
        ouch
      ];

      nixpkgs = {
        hostPlatform = "x86_64-linux";
        config.allowUnfree = true;
      };

      nix.settings = {
        # substituters = lib.mkForce [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };

      time.timeZone = "Asia/Shanghai";
    };
}
