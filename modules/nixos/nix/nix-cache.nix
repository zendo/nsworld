{ inputs, ... }:
{
  flake.modules.nixos.nix-cache =
    { lib, ... }:
    {
      # optimizing Nix cache routes for fast access
      imports = [ inputs.ncro.nixosModules.default ];

      nix.settings.substituters = lib.mkForce [ "http://localhost:8088" ];

      services.ncro = {
        enable = true;
        settings = {
          server.listen = ":8088";
          upstreams = [
            {
              url = "https://mirrors.ustc.edu.cn/nix-channels/store";
              priority = 10;
            }
            {
              url = "https://mirror.sjtu.edu.cn/nix-channels/store";
              priority = 10;
            }
            {
              url = "https://cache.nixos.org";
              priority = 20;
            }
            {
              url = "https://cache.garnix.io";
              priority = 20;
            }
            {
              url = "https://nix-community.cachix.org";
              priority = 20;
            }
          ];
        };
      };

    };
}
