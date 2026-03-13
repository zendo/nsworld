/*
  https://github.com/Mic92/sops-nix
  https://michael.stapelberg.ch/posts/2025-08-24-secret-management-with-sops-nix/

  mkdir -p ~/.config/sops/age

  - Using host ssh key
  [remote]: sudo ssh-to-age -private-key -i /var/lib/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt | age-keygen -y
  [main]: ssh-to-age -private-key -i ~/.ssh/id_ed25519 -o ~/.config/sops/age/keys.txt
  chmod 600 ~/.config/sops/age/keys.txt

  - Paste into .sops.yaml
  cat /var/lib/ssh/ssh_host_ed25519_key.pub | ssh-to-age
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
