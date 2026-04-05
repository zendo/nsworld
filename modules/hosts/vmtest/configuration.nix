{ inputs, ... }:
let
  userName = "test";
in
{
  # nixos-rebuild build-vm --flake .#vmtest
  # nix build .#nixosConfigurations.vmtest.config.system.build.vm
  flake.nixosConfigurations.vmtest = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with inputs.self.modules.nixos;
      [
        host-vmtest
        hmModule

        base
        fonts
        nixconfig
        nixpkgs
        ssh
        zsh
        # nix-ld
        gnome
      ]
      ++ [
        "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
        # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
      ];
  };

  flake.modules.nixos.host-vmtest =
    { pkgs, ... }:
    {
      home-manager.users.${userName} = {
        imports = [
          inputs.self.modules.homeManager.default-imports
        ];
      };

      disabledModules = [
        # "services/desktops/pipewire/pipewire.nix"
      ];

      environment.systemPackages = with pkgs; [
        dippi
      ];

      environment.variables = { };

      # Clipboard shared for NixOS@Guest
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
      services.spice-webdavd.enable = true;

      # ./result/bin/run-vm -m 4G -smp 4 -device virtio-vga-gl -display sdl,gl=on
      virtualisation = {
        memorySize = 1024 * 4;
        diskSize = 1024 * 8;
        cores = 8;
        msize = 104857600; # 100M
        qemu = {
          options = [
            # Sounds
            "-audiodev pa,id=snd0"
            "-device ich9-intel-hda"
            "-device hda-duplex,audiodev=snd0"
            # Graphical for sway
            # "-vga qxl"
            # Wayland in QEMU
            "-device virtio-vga-gl"
            "-display gtk,gl=on"
          ];
        };
      };

      nixpkgs.hostPlatform = "x86_64-linux";

      users.users.root.initialPassword = "root";
      users.users.${userName} = {
        isNormalUser = true;
        initialPassword = "test";
        extraGroups = [
          "wheel"
          "networkmanager"
          "input"
          "video"
          "adbusers"
          "docker"
          "podman"
        ];
      };

      security.sudo.wheelNeedsPassword = false;
      security.sudo-rs.wheelNeedsPassword = false;

      services.displayManager.autoLogin.user = userName;
      services.xserver = {
        # enable = true;
        desktopManager = {
          # gnome.enable = true;
          # xfce.enable = true;
          # budgie.enable = true;
          # deepin.enable = true;
          # cinnamon.enable = true;
          # pantheon.enable = true;
          # enlightenment.enable = true;
          # mate.enable = true;
          # lxqt.enable = true;
        };
      };

    };
}
