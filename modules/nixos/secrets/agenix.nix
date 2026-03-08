/*
  https://github.com/ryantm/agenix
  https://fzakaria.com/2024/07/12/nix-secrets-for-dummies
  https://github.com/yaxitech/ragenix
  https://github.com/oddlama/agenix-rekey
  https://github.com/GaetanLepage/nix-config/blob/master/modules/nixos/core/agenix.nix
*/
{
  self,
  ...
}:
{
  # sudo ls /run/agenix/
  age.secrets = {
    dae.file = (self + /modules/agenix/dae.age);
  };
}
