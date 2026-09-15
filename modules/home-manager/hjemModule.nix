{ inputs, config, ... }:
let
  fm = config.flake.modules;
in
{
  flake.modules.nixos.hjemModule = { config, ... }: {

    imports = [ inputs.omniflake.flakes.hjem.nixosModules.default ];

    hjem.specialArgs.hjemUser = config.myVars.user;

    hjem.users.${config.myVars.user} = {
      directory = "/home/${config.myVars.user}";
      imports = [ fm.hjem.files ];
    };

  };
}
