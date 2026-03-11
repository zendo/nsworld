{
  inputs,
  self,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    (self + /modules/secrets/sopsnix.nix)

    inputs.agenix.nixosModules.default
    (self + /modules/secrets/agenix.nix)
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # defined already = `config.services.openssh.hostKeys`
  # age.identityPaths = [];

  environment.systemPackages = with pkgs; [
    age
    # rage # age encrypt RIIR
    ssh-to-age
    sops
    ragenix
  ];
}
