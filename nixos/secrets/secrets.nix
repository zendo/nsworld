# https://blog.sekun.net/posts/manage-secrets-in-nixos/
# https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/
# https://www.youtube.com/watch?v=G5f6GC7SnhU
# https://unmovedcentre.com/posts/secrets-management/

/*
  mkdir -p ~/.config/sops/age

  # Generate a key
  age-keygen -o ~/.config/sops/age/keys.txt
  # or Using own ssh key
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

  # Print out and put in .sops.yaml
  age-keygen -y ~/.config/sops/age/keys.txt

  # decrypt and show the real value
  sops --extract '["hello"]' --decrypt secrets/secrets.yaml
*/
{ inputs, username, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      # this will use an age key that is expected to already be in the filesystem
      # age.keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };
  };
}
