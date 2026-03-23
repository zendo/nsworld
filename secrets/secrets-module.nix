/*
  https://github.com/ryantm/agenix
  https://github.com/oddlama/agenix-rekey
  https://fzakaria.com/2024/07/12/nix-secrets-for-dummies
  https://github.com/Mic92/sops-nix
  https://michael.stapelberg.ch/posts/2025-08-24-secret-management-with-sops-nix/

  mkdir -p ~/.config/sops/age

  - Using host ssh key
  [private]: ssh-to-age -private-key -i ~/.ssh/id_ed25519 -o ~/.config/sops/age/keys.txt
  [remote]: sudo ssh-to-age -private-key -i /var/lib/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt | age-keygen -y
  chmod 600 ~/.config/sops/age/keys.txt

  - Paste into .sops.yaml
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 | age-keygen -y
  cat /var/lib/ssh/ssh_host_ed25519_key.pub | ssh-to-age

  - Edit
  sops ~/nsworld/secrets/sopsnix.yaml

  - Update all secrets when key changed
  sops updatekeys ~/nsworld/secrets/sopsnix.yaml

  - Decrypt and show the real value
  sops --extract '["dae_sub"]' --decrypt ~/nsworld/secrets/sopsnix.yaml
*/
let
  agenixSecrets = {
    dae.file = ./dae.age;
    infini_pass.file = ./infini_pass.age;
  };

  sopsSecrets = {
    rclone_infini_pass = { };
    rclone_koofr_pass = { };
    access_tokens = { };
    dae_sub = { };
  };
in
{
  flake.modules.nixos.secrets =
    {
      inputs,
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.agenix.nixosModules.default
        inputs.sops-nix.nixosModules.sops
      ];

      age.secrets = agenixSecrets;
      # age.identityPaths = [ ]; # defined already

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
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
    };

  # ╭─────────────────────────────────────────────────────╮
  # │  Home-manager                                       │
  # ╰─────────────────────────────────────────────────────╯
  flake.modules.homeManager.secrets =
    {
      inputs,
      config,
      ...
    }:
    {
      imports = [
        inputs.agenix.homeManagerModules.default
        inputs.sops-nix.homeManagerModules.sops
      ];

      age.secrets = agenixSecrets;
      # age.identityPaths = [ ]; # defined already

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
      sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
}
