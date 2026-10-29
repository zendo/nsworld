{ inputs, config, ... }:
{
  flake.nixosConfigurations.vm-dev = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.host-vm-dev
    ];
  };

  # https://www.tweag.io/blog/2026-10-29-running-local-dev-services-with-nix/
  flake.modules.nixos.host-vm-dev =
    { pkgs, modulesPath, ... }:
    {
      imports = [
        "${modulesPath}/profiles/qemu-guest.nix"
        "${modulesPath}/virtualisation/qemu-vm.nix"
      ];

      environment.systemPackages = with pkgs; [
        ttt
      ];

      programs.bash.shellInit = ''
        bind -x '"\C-k": poweroff'
      '';

      virtualisation.graphics = false;
      networking.firewall.enable = false;
      services.getty.autologinUser = "root";
      nixpkgs.hostPlatform = "x86_64-linux";
      system.stateVersion = "26.05";
    };

  perSystem = {
    # nix run .#vm-dev
    packages.vm-dev = config.flake.nixosConfigurations.vm-dev.config.system.build.vm;
  };
}
