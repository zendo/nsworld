{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      virtualisation = {
        # docker = {
        #   enable = true;
        #   autoPrune.enable = true;
        #   enableOnBoot = true;
        # };

        podman = {
          enable = true;
          autoPrune.enable = true;
          dockerCompat = true;
        };

        containers.registries.settings = {
          unqualified-search-registries = [ "docker.io" ];
        };

      };
    };
}
