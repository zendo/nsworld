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

  # sudo cp /var/lib/ssh/ssh_host_ed25519_key  ~/.ssh/id_ed25519
  # sudo cp /var/lib/ssh/ssh_host_ed25519_key.pub ~/.ssh/id_ed25519.pub
  # sudo chown -R $USER  ~/.ssh

  # agenix
  # age.identityPaths = [ ]; # defined already

  # sops-nix
  sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
}
