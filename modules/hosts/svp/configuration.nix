{ inputs, config, ... }:
let
  userName = "zendo";
  hostName = "svp";
  fm = config.flake.modules;
in
{
  flake.nixosConfigurations.svp = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with fm.nixos;
      [
        host-svp
        host-svp-disko-btrfs

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
        inputs.nixos-hardware.nixosModules.common-gpu-intel
      ];
  };

  flake.modules.nixos.host-svp =
    { config, ... }:
    {
      myVars.user = userName;
      networking.hostName = hostName;

      home-manager.users.${config.myVars.user} = {
        imports = [ fm.homeManager.default-imports ];
        # programs.vscode.enable = true;
      };

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
