/*
  distrobox create -i archlinux
  toolbox create -i quay.io/toolbx/arch-toolbox  / ubuntu-toolbox
*/
{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # lazydocker
        # docker-compose
        podman-compose
        compose2nix # compose2nix -project=my
        pods
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

        containers.registries.settings = {
          unqualified-search-registries = [ "docker.io" ];
        };

      };
    };
}
