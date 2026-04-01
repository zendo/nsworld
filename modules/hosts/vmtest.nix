{ inputs, self, ... }:
let
  userName = "test";
in
{
  # nixos-rebuild build-vm --flake .#vmtest
  # nix build .#nixosConfigurations.vmtest.config.system.build.vm
  flake.nixosConfigurations.vmtest = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
      # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"

      self.modules.nixos.host-vmtest
      self.modules.nixos.hmModule

      self.modules.nixos.base
      self.modules.nixos.fonts
      self.modules.nixos.nixconfig
      self.modules.nixos.nixpkgs
      self.modules.nixos.ssh
      self.modules.nixos.zsh
      # self.modules.nixos.nix-ld
      self.modules.nixos.gnome
    ];
  };

  flake.modules.nixos.host-vmtest =
    { pkgs, ... }:
    {
      home-manager.users.${userName} = {
        imports = [
          self.modules.homeManager.default-imports
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

      users.users.${userName} = {
        isNormalUser = true;
        # pw: test
        initialHashedPassword = "$y$j9T$cwgM31P53Jvlqq2Ed/ad0.$t1G8tnJg7DsspO2687hpTO87v2uSVfB9E5hpBufYhR.";
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

      # pw: root
      users.users.root.initialHashedPassword = "$y$j9T$0t8NyDpq3ikgERiGgdPru0$pI6bTECjj2pSb68lF.U0xpftH.2vTF26uiRasZnROD3";

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
