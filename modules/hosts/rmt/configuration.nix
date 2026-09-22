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
      hjemModule
      # hm-imports
      nixos-imports

      # [ profiles ]
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

      environment.systemPackages = with pkgs; [
        duf
        gdu
      ];

      services.displayManager.autoLogin.user = "${config.myVars.user}";

      users.users.${config.myVars.user} = {
        # pw: 123
        hashedPassword = "$y$j9T$HMRcTJOCJnmqDmH2cPVGF.$ZeGBjMnWDDpnicBGlVGZGNSkEXxdI7jLvm3GHK8eqVA";
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

      boot.loader = {
        efi.efiSysMountPoint = "/efi";
        limine.enable = true;
      };
    };
}
