{
  inputs,
  self,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
    (self + /modules/secrets/agenix.nix)

    inputs.sops-nix.nixosModules.sops
    (self + /modules/secrets/sopsnix.nix)
  ];

  # agenix
  # age.identityPaths = [ ]; # defined already

  # sops-nix
  # Copy: https://github.com/ryantm/agenix/blob/main/modules/age.nix#L241
  sops.age.sshKeyPaths = map (e: e.path) (
    lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
  );

  environment.systemPackages = with pkgs; [
    age
    # rage # age encrypt RIIR
    ssh-to-age
    sops
    ragenix
  ];
}
