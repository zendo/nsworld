{ inputs, config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.hjemModule = { config, ... }: {
    imports = [ inputs.omniflake.flakes.hjem.nixosModules.default ];

    # nix eval --json .#modules.hjem --apply builtins.attrNames | jq -r '.[]'
    hjem.users.${config.myVars.user} = {
      directory = "/home/${config.myVars.user}";
      clobberFiles = true; # overwrite existing files
      imports = [
        fm.hjem.files
        # fm.hjem.systemd
      ];
    };

  };
}
