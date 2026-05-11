{ inputs, config, ... }:
let
  userName = "aaa";
  hostName = "rmt";
  fm = config.flake.modules;
in
{
  # nixos-rebuild --target-host user@host -S --flake .#host switch
  flake.nixosConfigurations.rmt = inputs.nixpkgs.lib.nixosSystem {
    modules = with fm.nixos; [
      host-rmt
      # host-rmt-disko-btrfs
      host-rmt-disko-bcachefs

      # [ profiles ]
      hmModule
      default-imports
      # laptop
      # steam

      # [ virt ]
      # docker
      # incus
      # nix-ld
      # qemu

      # [ desktop ]
      graphical
      gnome
      # kde
      # cosmic
      # niri
      # sway
      # hyprland
    ];
  };

  flake.modules.nixos.host-rmt =
    { pkgs, config, ... }:
    {
      myVars.user = userName;
      networking.hostName = hostName;

      home-manager.users.${config.myVars.user} = {
        imports = [ fm.homeManager.default-imports ];
        # programs.vscode.enable = true;
      };

      environment.systemPackages = with pkgs; [
        duf
        gdu
      ];

      # Desktop Environment
      services = {
        displayManager.autoLogin.user = "${config.myVars.user}";
        xserver = {
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

      # Clipboard shared for NixOS@Guest
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
      # FIXME
      # https://github.com/NixOS/nixpkgs/issues/481078
      # https://github.com/NixOS/nixpkgs/pull/266080
      systemd.user.services.spice-vdagent = {
        description = "spice-vdagent user daemon";
        after = [
          "spice-vdagentd.service"
          "graphical-session.target"
        ];
        requires = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
        };
        unitConfig = {
          ConditionPathExists = "/run/spice-vdagentd/spice-vdagent-sock";
        };
      };

      users.users.${config.myVars.user} = {
        # pw: 123
        hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
      };

      boot.loader = {
        efi.efiSysMountPoint = "/efi";
        limine.enable = true;
      };
    };
}
