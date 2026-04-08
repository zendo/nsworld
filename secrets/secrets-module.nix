/*
  https://github.com/ryantm/agenix
  https://github.com/Mic92/sops-nix
  https://github.com/oddlama/agenix-rekey
  https://michael.stapelberg.ch/posts/2025-08-24-secret-management-with-sops-nix/

  - Convert ssh key to age
  mkdir -p ~/.config/sops/age
  [private]: ssh-to-age -private-key -i ~/.ssh/id_ed25519 -o ~/.config/sops/age/keys.txt
  [remote]: sudo ssh-to-age -private-key -i /var/lib/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt
  sudo chmod 600 ~/.config/sops/age/keys.txt

  - Paste into .sops.yaml & secrets.nix
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 | age-keygen -y
  cat /var/lib/ssh/ssh_host_ed25519_key.pub | ssh-to-age

  - Edit
  sops ~/nsworld/secrets/sopsnix.yaml

  - Update all secrets when key changed
  sops updatekeys ~/nsworld/secrets/sopsnix.yaml

  - Decrypt and show the real value
  sops --extract '["dae_sub"]' --decrypt ~/nsworld/secrets/sopsnix.yaml
*/
{ inputs, ... }:
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
    { lib, config, ... }:
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
    };

  flake.modules.homeManager.secrets =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.agenix.homeManagerModules.default
        inputs.sops-nix.homeManagerModules.sops
      ];

      age.secrets = agenixSecrets;
      age.identityPaths = [ "${config.home.homeDirectory}/.config/sops/age/keys.txt" ];

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
      # sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      home.packages = with pkgs; [
        age
        # rage # age encrypt RIIR
        ssh-to-age
        sops
        ragenix
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      devshells.secrets = {
        packages = with pkgs; [
          age
          # rage # age encrypt RIIR
          ssh-to-age
          sops
          ragenix
        ];
        commands = [
          {
            name = "secrets-hostkey-to-age";
            command = ''
              echo "=> Generate host-key to age"
              mkdir -p ~/.config/sops/age
              sudo ssh-to-age -private-key -i /var/lib/ssh/ssh_host_ed25519_key \
                                           -o ~/.config/sops/age/keys.txt
              sudo chmod 600 ~/.config/sops/age/keys.txt
              cat /var/lib/ssh/ssh_host_ed25519_key.pub
              sudo age-keygen -y ~/.config/sops/age/keys.txt
            '';
          }
          # {
          #   name = "secrets-copy-hostkey-to-home";
          #   command = ''
          #     echo "=> Copy host key to home"
          #     [ -f "$HOME/.ssh/id_ed25519" ] && echo "Do nothing."; exit 0
          #     read -p "Are u sure? (y/n): " res
          #     [[ "$res" =~ ^[Yy](es)?$ ]] || exit 1
          #     sudo cp /var/lib/ssh/ssh_host_ed25519_key  ~/.ssh/id_ed25519
          #     sudo cp /var/lib/ssh/ssh_host_ed25519_key.pub ~/.ssh/id_ed25519.pub
          #     sudo chown -R $USER  ~/.ssh
          #     echo "Done."
          #   '';
          # }
        ];
      };
    };
}
