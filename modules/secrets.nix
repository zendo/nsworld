{ inputs, ... }:
let
  sopsSecrets = {
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
  flake.modules.nixos.nix-secrets =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.omniflake.flakes.nix-secrets.nixosModules.default ];

      security.nix-secrets = {
        enable = true;
        storage = ../secrets; # Relative path to your `secrets` (copied to /nix/store)
        identityPaths = [
          "/home/user/keys.txt" # Path to your age private key
          "/home/user/.ssh/id_ed25519" # You can also use SSH keys
        ];
        recipientAliases = {
          first = "age14e2jdmau7tpau9emcn6gmg26vfl0uyf6cfd9lz85jml6ttv9wq2qphps4t"; # Your age recipient (public key)
          ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuUsB0HH//1qkvgQMWTEoNd0riZpk+8A5w1Ep2vGKk0"; # Or your SSH public key
        };
        # Add your secrets here...
        secrets = {
          password.recipients = [ "first" ];
          signingKey.recipients = [ "ssh" ];
        };
      };
    };

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
