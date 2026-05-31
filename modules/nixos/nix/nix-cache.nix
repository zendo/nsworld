{ inputs, ... }:
{
  flake.modules.nixos.nix-cache =
    let
      # https://github.com/feel-co/ncro
      ncro =
        { lib, config, ... }:
        {
          imports = [ inputs.ncro.nixosModules.default ];
          nix.settings.substituters = lib.mkForce [
            "http://localhost${config.services.ncro.settings.server.listen}"
          ];

          services.ncro = {
            enable = true;
            settings = {
              server.listen = ":8088";
              upstreams = [
                {
                  url = "https://mirrors.ustc.edu.cn/nix-channels/store";
                  priority = 10;
                }
                # {
                #   url = "https://mirror.sjtu.edu.cn/nix-channels/store";
                #   priority = 10;
                # }
                {
                  url = "https://cache.nixos.org";
                  priority = 15;
                }
                {
                  url = "https://nix-community.cachix.org";
                  priority = 20;
                }
              ];
            };
          };
        };

      # https://github.com/StarryReverie/selector4nix/blob/master/docs/configuration.md
      selector4nix = {
        imports = [ inputs.selector4nix.nixosModules.selector4nix ];

        services.selector4nix = {
          enable = true;
          # Alternatives are "keep" (default) and "prepend".
          configureSubstituter = "overwrite";
          settings = {
            server.port = 8089;
            substituters = [
              {
                url = "https://mirrors.ustc.edu.cn/nix-channels/store";
                priority = 10; # Default: 40
              }
              # {
              #   url = "https://mirror.sjtu.edu.cn/nix-channels/store";
              #   priority = 10;
              # }
              {
                url = "https://cache.nixos.org";
              }
              { url = "https://nix-community.cachix.org"; }
            ];
          };
        };
      };
    in
    ncro;
}
