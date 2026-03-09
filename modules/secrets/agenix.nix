/*
  https://github.com/ryantm/agenix
  https://fzakaria.com/2024/07/12/nix-secrets-for-dummies
  https://github.com/oddlama/agenix-rekey
  https://github.com/GaetanLepage/nix-config/blob/master/modules/nixos/core/agenix.nix
*/
{ ... }:
{
  # sudo ls /run/agenix/
  age.secrets = {
    # dae.file = ./dae.age;
    # rclone_infini_pass.file = ./rclone_infini_pass.age;
  };
}
