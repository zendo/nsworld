{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
    (inputs.self + /modules/secrets/agenix.nix)

    inputs.sops-nix.homeManagerModules.sops
    (inputs.self + /modules/secrets/sopsnix.nix)
  ];

  # agenix
  # age.identityPaths = [ ]; # defined already

  # sops-nix
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
}
