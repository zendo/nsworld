/*
  distrobox create -i archlinux
  toolbox create -i quay.io/toolbx/arch-toolbox  / ubuntu-toolbox
*/
{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        distrobox
        # toolbox
      ];

      virtualisation = {
        # docker = {
        #   enable = true;
        #   autoPrune.enable = true;
        #   enableOnBoot = true;
        # };

        podman = {
          enable = true;
          dockerCompat = true;
        };

        # containers = {
        #   enable = true;
        #   registries.search = [
        #     "docker.io"
        #     "quay.io"
        #     "registry.opensuse.org"
        #   ];
        # };
      };
    };
}
