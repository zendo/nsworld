/*
  https://github.com/ryantm/agenix
  https://fzakaria.com/2024/07/12/nix-secrets-for-dummies
  https://github.com/yaxitech/ragenix
  https://github.com/GaetanLepage/nix-config/blob/master/modules/nixos/core/agenix.nix
*/
{ inputs, self, ... }:
{
  # module
  imports = [
    inputs.agenix.nixosModules.default
  ];

  # app
  environment.systemPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];

  # sudo ls /run/agenix/
  age.secrets = {
    dae.file = (self + /modules/agenix/dae.age);
  };
}
