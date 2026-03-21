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
        ./agenix.nix

        inputs.sops-nix.nixosModules.sops
        ./sopsnix.nix
      ];

      # agenix
      # age.identityPaths = [ ]; # defined already

      # sops-nix
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
        ./agenix.nix

        inputs.sops-nix.homeManagerModules.sops
        ./sopsnix.nix
      ];

      # agenix
      # age.identityPaths = [ ]; # defined already

      # sops-nix
      sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    };
}
