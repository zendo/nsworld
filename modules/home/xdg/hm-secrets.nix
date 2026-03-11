{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    (inputs.self + /modules/secrets/sopsnix.nix)

    inputs.agenix.homeManagerModules.default
    (inputs.self + /modules/secrets/agenix.nix)
  ];

  # agenix
  # sudo cp /etc/ssh/ssh_host_ed25519_key  ~/.ssh/id_ed25519
  # sudo cp /etc/ssh/ssh_host_ed25519_key.pub ~/.ssh/id_ed25519.pub
  # sudo chown -R $USER  ~/.ssh
  age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

  # sops-nix
  # mkdir -p ~/.config/sops/age
  # sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key -o ~/.config/sops/age/keys.txt
  # chmod 600 ~/.config/sops/age/keys.txt
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

}
