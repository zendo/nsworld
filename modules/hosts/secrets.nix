{ inputs, ... }:
let
  sopsSecrets = {
    rclone_infini_pass = { };
    rclone_koofr_pass = { };
    dae_sub = { };
  };

  secret-apps =
    pkgs: with pkgs; [
      age
      # rage # age RIIR
      ssh-to-age
      # ragenix # agenix
      sops
    ];
in
{
  flake.modules.nixos.secrets =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.omniflake.flakes.sops-nix.nixosModules.sops ];

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
      # Copy: https://github.com/ryantm/agenix/blob/main/modules/age.nix#L241
      sops.age.sshKeyPaths = map (e: e.path) (
        lib.filter (e: e.type == "rsa" || e.type == "ed25519") config.services.openssh.hostKeys
      );

      environment.systemPackages = secret-apps pkgs;
    };

  flake.modules.homeManager.secrets =
    { config, pkgs, ... }:
    {
      imports = [ inputs.omniflake.flakes.sops-nix.homeManagerModules.sops ];

      sops.secrets = sopsSecrets;
      sops.defaultSopsFile = ./sopsnix.yaml;
      sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      home.packages = secret-apps pkgs;
    };

  perSystem =
    { pkgs, ... }:
    {
      devshells.nsw-secrets = {
        packages = secret-apps pkgs;
        commands = [
          {
            name = "secrets-hostkey-to-age";
            command = ''
              KEY_FILE="$HOME/.config/sops/age/keys.txt"
              SSH_KEY="/var/lib/ssh/ssh_host_ed25519_key"
              echo "=> Preparing age host-key"
              if [ -f "$KEY_FILE" ]; then
                  echo "Age key already exists. Skipping..."
              else
                  mkdir -p "$(dirname "$KEY_FILE")"
                  sudo ssh-to-age -private-key -i "$SSH_KEY" -o "$KEY_FILE"
                  sudo chown "$(id -u):$(id -g)" "$KEY_FILE"
              fi
              echo "Public Key ssh/age:"
              cat "''${SSH_KEY}.pub"
              ssh-to-age < "''${SSH_KEY}.pub"
            '';
          }
        ];
      };
    };
}
