{ inputs, config, ... }:
let
  userName = "test";
  fm = config.flake.modules;
in
{
  # nixos-rebuild build-vm --flake .#vm-test
  # nix build .#nixosConfigurations.vm-test.config.system.build.vm
  flake.nixosConfigurations.vm-test = inputs.nixpkgs.lib.nixosSystem {
    modules =
      with fm.nixos;
      [
        host-vm-test
        # hjemModule
        # hm-imports
        # nixos-imports

        myvars
        # secrets
        programs
        services
        selfhosted

        base
        boot
        user
        fonts
        nixconfig
        nixpkgs
        ssh
        # nix-ld
        graphical
        gnome
      ]
      ++ [
        "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
        # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
      ];
  };

  flake.modules.nixos.host-vm-test =
    { pkgs, ... }:
    {
      myVars.user = userName;
      users.users.${userName}.password = "123";
      # users.defaultUserShell = pkgs.zsh;

      disabledModules = [
        # "services/desktops/pipewire/pipewire.nix"
      ];

      environment.systemPackages = with pkgs; [
        ttt
      ];

      environment.variables = { };

      # Clipboard shared for NixOS@Guest
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
      # services.spice-webdavd.enable = true; # :davfs

      # ./result/bin/run-vm -m 4G -smp 4 -device virtio-vga-gl -display sdl,gl=on
      virtualisation = {
        memorySize = 1024 * 4;
        diskSize = 1024 * 8;
        cores = 8;

        # 宿主机 127.0.0.1:2222 -> guest:22，用于 ssh 进本 VM。
        # slirp 的 10.0.2.15 在宿主机不可达，必须由 QEMU 做端口转发；
        # 绑 127.0.0.1 表示只允许本机访问，不暴露给 LAN。
        forwardPorts = [
          {
            from = "host";
            host.address = "127.0.0.1";
            host.port = 2222;
            guest.port = 22;
          }
        ];
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

  perSystem = {
    # nix run .#vm-test
    packages.vm-test = config.flake.nixosConfigurations.vm-test.config.system.build.vm;
  };
}
