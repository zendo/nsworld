/*
  https://github.com/Mic92/sops-nix
  https://michael.stapelberg.ch/posts/2025-08-24-secret-management-with-sops-nix/

  mkdir -p ~/.config/sops/age

  - Using host ssh key
  sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt | age-keygen -y
  chmod 600 ~/.config/sops/age/keys.txt

  - Paste into .sops.yaml
  cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 | age-keygen -y

  - Edit
  sops ~/nsworld/modules/secrets/sopsnix.yaml

  - Update all secrets when key changed
  sops updatekeys modules/secrets/sopsnix.yaml

  - Decrypt and show the real value
  sops --extract '["dae-sub"]' --decrypt modules/nixos/secrets/sopsnix.yaml
*/

{ ... }:
{
  sops.defaultSopsFile = ./sopsnix.yaml;

  sops.secrets = {
    rclone_infini_pass = { };
    access_tokens = { };
    dae_sub = { };
  };
}
