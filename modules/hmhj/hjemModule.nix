{ inputs, config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.hjemModule = { config, ... }: {
    imports = [ inputs.omniflake.flakes.hjem.nixosModules.default ];

    # overwrite existing files
    hjem.clobberByDefault = true;

    # nix eval --json .#modules.hjem --apply builtins.attrNames | jq -r '.[]'
    hjem.users.${config.myVars.user} = {
      directory = "/home/${config.myVars.user}";
      imports = [ fm.hjem.files ];
    };

  };
}
