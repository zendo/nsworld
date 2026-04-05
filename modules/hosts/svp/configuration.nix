{ inputs, ... }:
{
  flake.nixosConfigurations.svp = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules =
      with inputs.self.modules.nixos;
      [
        host-svp

        # [ profiles ]
        hmModule
        default-imports
        laptop
        # steam

        # [ virt ]
        docker
        # incus
        # nix-ld
        qemu

        # [ desktop ]
        graphical
        gnome
        # kde
        # cosmic
        # niri
        # sway
        # hyprland
      ]
      ++ [
        ./_disko-btrfs.nix
        inputs.nixos-hardware.nixosModules.common-gpu-intel
      ];
  };

  flake.modules.nixos.host-svp =
    {
      config,
      ...
    }:
    {
      myVars.user = "zendo";
      networking.hostName = "svp";

      home-manager.users.${config.myVars.user}.imports = [
        inputs.self.modules.homeManager.default-imports
      ];

      users.users.${config.myVars.user} = {
        # pw: 123
        hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
      };

      # ╭─────────────────────────────────────────────────────╮
      # │ HARDWARE                                            │
      # ╰─────────────────────────────────────────────────────╯
      boot.supportedFilesystems = [ "ntfs" ];

      zramSwap.enable = true;

      # Swapfile
      swapDevices = [
        {
          device = "/var/swapfile";
          size = 1024 * 8;
        }
      ];

      # ╭─────────────────────────────────────────────────────╮
      # │ BOOTLOADER                                          │
      # ╰─────────────────────────────────────────────────────╯
      boot.loader = {
        efi.efiSysMountPoint = "/efi";
        limine = {
          enable = true;
          style.wallpapers = [ ];
          style.interface.branding = " ";
        };
      };
    };
}
