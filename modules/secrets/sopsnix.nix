/*
  mkdir -p ~/.config/sops/age

  # Using own private ssh key [keyFile]
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt | age-keygen -y
  # and host ssh key [sshKeyPaths]
  cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age

  # Paste into .sops.yaml

  # Edit
  sops ~/nsworld/modules/secrets/sopsnix.yaml

  # Update all secrets when key changed
  sops updatekeys modules/secrets/sopsnix.yaml

  # Decrypt and show the real value
  sops --extract '["dae-sub"]' --decrypt modules/nixos/secrets/sopsnix.yaml
*/
{
  sops = {
    defaultSopsFile = ./sopsnix.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
